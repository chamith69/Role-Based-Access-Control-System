-- Roles table
CREATE TABLE IF NOT EXISTS roles (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text UNIQUE NOT NULL,
    description text,
    created_at timestamptz DEFAULT now()
);

-- Permissions table
CREATE TABLE IF NOT EXISTS permissions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name text UNIQUE NOT NULL,
    description text,
    created_at timestamptz DEFAULT now()
);

-- Role permissions junction table
CREATE TABLE IF NOT EXISTS role_permissions (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    role_id uuid REFERENCES roles(id) ON DELETE CASCADE,
    permission_id uuid REFERENCES permissions(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),
    UNIQUE(role_id, permission_id)
);

-- User roles junction table
CREATE TABLE IF NOT EXISTS user_roles (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE,
    role_id uuid REFERENCES roles(id) ON DELETE CASCADE,
    created_at timestamptz DEFAULT now(),
    UNIQUE(user_id, role_id)
);

-- Audit logs table
CREATE TABLE IF NOT EXISTS audit_logs (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
    action text NOT NULL,
    details jsonb DEFAULT '{}',
    created_at timestamptz DEFAULT now()
);

-- Enable RLS
ALTER TABLE roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE role_permissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_roles ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;

-- RLS Policies
CREATE POLICY "Allow read access to authenticated users"
ON roles FOR SELECT TO authenticated
USING (true);

CREATE POLICY "Allow read access to authenticated users"
ON permissions FOR SELECT TO authenticated
USING (true);

CREATE POLICY "Allow read access to authenticated users"
ON role_permissions FOR SELECT TO authenticated
USING (true);

CREATE POLICY "Allow read access to authenticated users"
ON user_roles FOR SELECT TO authenticated
USING (true);

CREATE POLICY "Allow read access to authenticated users"
ON audit_logs FOR SELECT TO authenticated
USING (true);

-- Admin policies
CREATE POLICY "Allow full access to admin role"
ON roles FOR ALL TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM user_roles ur
        JOIN roles r ON ur.role_id = r.id
        WHERE ur.user_id = auth.uid()
        AND r.name = 'admin'
    )
);

-- Insert default roles and permissions
INSERT INTO roles (name, description) VALUES
('admin', 'Full system access'),
('manager', 'Department management access'),
('user', 'Basic user access')
ON CONFLICT (name) DO NOTHING;

INSERT INTO permissions (name, description) VALUES
('users.view', 'View users'),
('users.create', 'Create users'),
('users.edit', 'Edit users'),
('users.delete', 'Delete users'),
('roles.view', 'View roles'),
('roles.manage', 'Manage roles')
ON CONFLICT (name) DO NOTHING;