<?php
/**
 * Service de monitoring système
 * Récupère les métriques CPU, RAM, Disque
 * 
 * SÉCURITÉ CRITIQUE:
 * - Utilise shell_exec() uniquement avec des commandes statiques
 * - Pas de paramètres utilisateur dans les commandes shell
 * - Toutes les lectures sont en lecture seule (/proc, /sys)
 */
namespace App\Services;

class ServerMonitor {
    
    /**
     * Récupère les statistiques du serveur
     */
    public static function getStats(): array {
        return [
            'cpu' => self::getCpuUsage(),
            'memory' => self::getMemoryUsage(),
            'disk' => self::getDiskUsage(),
            'uptime' => self::getUptime(),
            'temperature' => self::getTemperature(),
            'timestamp' => time()
        ];
    }

    /**
     * Charge CPU (moyenne sur 1 minute)
     */
    private static function getCpuUsage(): array {
        if (PHP_OS_FAMILY === 'Windows') {
            // Windows - utilise WMIC
            $output = shell_exec('wmic cpu get loadpercentage');
            preg_match('/\d+/', $output, $matches);
            $usage = isset($matches[0]) ? (int)$matches[0] : 0;
        } else {
            // Linux - lit /proc/loadavg
            $load = sys_getloadavg();
            $usage = round($load[0] * 100 / self::getCpuCores(), 2);
        }

        return [
            'percent' => $usage,
            'cores' => self::getCpuCores()
        ];
    }

    /**
     * Nombre de cœurs CPU
     */
    private static function getCpuCores(): int {
        if (PHP_OS_FAMILY === 'Windows') {
            $output = shell_exec('wmic cpu get NumberOfCores');
            preg_match('/\d+/', $output, $matches);
            return isset($matches[0]) ? (int)$matches[0] : 1;
        } else {
            return (int)shell_exec('nproc') ?: 1;
        }
    }

    /**
     * Utilisation mémoire
     */
    private static function getMemoryUsage(): array {
        if (PHP_OS_FAMILY === 'Windows') {
            $output = shell_exec('wmic OS get FreePhysicalMemory,TotalVisibleMemorySize /Value');
            preg_match('/FreePhysicalMemory=(\d+)/', $output, $free);
            preg_match('/TotalVisibleMemorySize=(\d+)/', $output, $total);
            
            $totalMb = isset($total[1]) ? round($total[1] / 1024, 2) : 0;
            $freeMb = isset($free[1]) ? round($free[1] / 1024, 2) : 0;
            $usedMb = $totalMb - $freeMb;
        } else {
            $meminfo = file_get_contents('/proc/meminfo');
            preg_match('/MemTotal:\s+(\d+)/', $meminfo, $total);
            preg_match('/MemAvailable:\s+(\d+)/', $meminfo, $available);
            
            $totalMb = round($total[1] / 1024, 2);
            $availableMb = round($available[1] / 1024, 2);
            $usedMb = $totalMb - $availableMb;
        }

        return [
            'total_mb' => $totalMb,
            'used_mb' => $usedMb,
            'free_mb' => $freeMb ?? $availableMb,
            'percent' => $totalMb > 0 ? round(($usedMb / $totalMb) * 100, 2) : 0
        ];
    }

    /**
     * Utilisation disque
     */
    private static function getDiskUsage(): array {
        $root = PHP_OS_FAMILY === 'Windows' ? 'C:' : '/';
        $totalSpace = disk_total_space($root);
        $freeSpace = disk_free_space($root);
        $usedSpace = $totalSpace - $freeSpace;

        return [
            'total_gb' => round($totalSpace / 1024 / 1024 / 1024, 2),
            'used_gb' => round($usedSpace / 1024 / 1024 / 1024, 2),
            'free_gb' => round($freeSpace / 1024 / 1024 / 1024, 2),
            'percent' => round(($usedSpace / $totalSpace) * 100, 2)
        ];
    }

    /**
     * Uptime du système
     */
    private static function getUptime(): array {
        if (PHP_OS_FAMILY === 'Windows') {
            $output = shell_exec('wmic os get lastbootuptime');
            preg_match('/(\d{14})/', $output, $matches);
            if (isset($matches[1])) {
                $bootTime = \DateTime::createFromFormat('YmdHis', substr($matches[1], 0, 14));
                $seconds = time() - $bootTime->getTimestamp();
            } else {
                $seconds = 0;
            }
        } else {
            $uptime = file_get_contents('/proc/uptime');
            $seconds = (int)floatval($uptime);
        }

        $days = floor($seconds / 86400);
        $hours = floor(($seconds % 86400) / 3600);
        $minutes = floor(($seconds % 3600) / 60);

        return [
            'seconds' => $seconds,
            'formatted' => "{$days}j {$hours}h {$minutes}m"
        ];
    }

    /**
     * Température CPU (si disponible)
     * NOTE: Nécessite l'accès au /sys/class/thermal du conteneur (voir docker-compose.yml)
     * Retourne null si pas d'accès aux capteurs (normal dans un conteneur non-privilégié)
     */
    private static function getTemperature(): ?array {
        if (PHP_OS_FAMILY === 'Windows') {
            // Windows - nécessite Open Hardware Monitor ou équivalent
            // Pour l'instant, retourner null
            return null;
        } else {
            // Linux - essaye de lire les capteurs thermiques
            // NOTE SÉCURITÉ: Lecture seule de fichiers système, pas de paramètres utilisateur
            $tempFiles = glob('/sys/class/thermal/thermal_zone*/temp');
            if (empty($tempFiles)) {
                return null; // Conteneur sans accès aux capteurs
            }

            $temps = [];
            foreach ($tempFiles as $file) {
                if (!is_readable($file)) continue;
                
                $content = @file_get_contents($file);
                if ($content === false) continue;
                
                $temp = (int)$content / 1000; // Convertir millidegrés en degrés
                $temps[] = $temp;
            }

            $avgTemp = round(array_sum($temps) / count($temps), 1);
            return [
                'celsius' => $avgTemp,
                'fahrenheit' => round(($avgTemp * 9/5) + 32, 1)
            ];
        }
    }
}
