<?php
namespace App\Services;

class Database {
    private static $instance = null;
    private $connection;

    private function __construct() {
        $host = getenv('DB_HOST') ?: 'mariadb';
        $dbname = getenv('DB_NAME') ?: 'portfolio_db';
        $user = getenv('DB_USER') ?: 'portfolio_user';
        $password = getenv('DB_PASSWORD') ?: 'ChangeMeInProduction123!';

        try {
            $this->connection = new \PDO(
                "mysql:host={$host};dbname={$dbname};charset=utf8mb4",
                $user,
                $password,
                [
                    \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
                    \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
                    \PDO::ATTR_EMULATE_PREPARES => false
                ]
            );
        } catch (\PDOException $e) {
            throw new \Exception("Database connection failed: " . $e->getMessage());
        }
    }

    public static function getInstance(): self {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function getConnection(): \PDO {
        return $this->connection;
    }

    public function query(string $sql, array $params = []): \PDOStatement {
        $stmt = $this->connection->prepare($sql);
        $stmt->execute($params);
        return $stmt;
    }

    public function fetchAll(string $sql, array $params = []): array {
        return $this->query($sql, $params)->fetchAll();
    }

    public function fetchOne(string $sql, array $params = []) {
        return $this->query($sql, $params)->fetch();
    }

    public function execute(string $sql, array $params = []): bool {
        return $this->query($sql, $params)->rowCount() > 0;
    }
}
