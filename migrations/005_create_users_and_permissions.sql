-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id TEXT PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL CHECK(role IN ('admin', 'user')),
    full_name TEXT,
    email TEXT,
    is_active BOOLEAN NOT NULL DEFAULT 1,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create user_servers junction table for many-to-many relationship
CREATE TABLE IF NOT EXISTS user_servers (
    user_id TEXT NOT NULL,
    server_id TEXT NOT NULL,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, server_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (server_id) REFERENCES servers(id) ON DELETE CASCADE
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_user_servers_user ON user_servers(user_id);
CREATE INDEX IF NOT EXISTS idx_user_servers_server ON user_servers(server_id);

-- Insert default admin user (password: Soft@26*)
-- Password hash for 'Soft@26*' using bcrypt
INSERT INTO users (id, username, password_hash, role, full_name, email, is_active)
VALUES (
    'admin-' || lower(hex(randomblob(16))),
    'servers',
    '$2b$12$ICkQC7U3muC9L73IvzXQTukyP7QtzHszziOtnq6GRjtMkOVVTPttu',
    'admin',
    'System Administrator',
    'admin@example.com',
    1
);
