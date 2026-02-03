<?php
namespace App\Services;

class DockerMonitor {
    
    /**
     * Récupère l'état de tous les conteneurs Docker
     */
    public static function getContainers(): array {
        if (!self::isDockerAvailable()) {
            return ['error' => 'Docker not available'];
        }

        $output = shell_exec('docker ps -a --format "{{.Names}}|{{.Status}}|{{.Image}}|{{.Ports}}"');
        if (empty($output)) {
            return [];
        }

        $containers = [];
        $lines = explode("\n", trim($output));
        
        foreach ($lines as $line) {
            if (empty($line)) continue;
            
            [$name, $status, $image, $ports] = explode('|', $line);
            
            $isRunning = strpos($status, 'Up') === 0;
            
            $containers[] = [
                'name' => $name,
                'image' => $image,
                'status' => $isRunning ? 'running' : 'stopped',
                'status_text' => $status,
                'ports' => $ports,
                'uptime' => self::parseUptime($status)
            ];
        }

        return $containers;
    }

    /**
     * Statistiques d'un conteneur spécifique
     */
    public static function getContainerStats(string $containerName): ?array {
        if (!self::isDockerAvailable()) {
            return null;
        }

        $output = shell_exec("docker stats {$containerName} --no-stream --format \"{{.CPUPerc}}|{{.MemUsage}}|{{.NetIO}}\"");
        if (empty($output)) {
            return null;
        }

        [$cpu, $memory, $network] = explode('|', trim($output));

        return [
            'cpu_percent' => rtrim($cpu, '%'),
            'memory_usage' => $memory,
            'network_io' => $network
        ];
    }

    /**
     * Vérifie si Docker est disponible
     */
    private static function isDockerAvailable(): bool {
        $output = shell_exec('docker --version 2>&1');
        return strpos($output, 'Docker version') !== false;
    }

    /**
     * Parse l'uptime depuis le status Docker
     */
    private static function parseUptime(string $status): ?string {
        if (preg_match('/Up (.+?)(?:\s+\(|$)/', $status, $matches)) {
            return $matches[1];
        }
        return null;
    }

    /**
     * Résumé global Docker
     */
    public static function getSummary(): array {
        $containers = self::getContainers();
        
        if (isset($containers['error'])) {
            return $containers;
        }

        $running = 0;
        $stopped = 0;

        foreach ($containers as $container) {
            if ($container['status'] === 'running') {
                $running++;
            } else {
                $stopped++;
            }
        }

        return [
            'total' => count($containers),
            'running' => $running,
            'stopped' => $stopped,
            'containers' => $containers
        ];
    }
}
