/*
  # Fix roles policies
  1. Changes
    - Drop existing policies
    - Avoid recursion by simplifying conditions and removing references that lead to indirect policy calls.
    - Separate access control for read and write operations for authenticated users and admins.
*/

-- Drop existing policies
DROP POLICY IF EXISTS "Anyone can read roles" ON roles;
DROP POLICY IF EXISTS "Admin users can manage roles" ON roles;

-- Create new policies
-- 1. Allow all authenticated users to read roles (No recursion here)
CREATE POLICY "Anyone can read roles"
ON roles FOR SELECT
TO authenticated
USING (true);  -- Allow anyone to read roles without checking user_roles

-- 2. Allow only admin users to insert new roles
CREATE POLICY "Admin users can insert roles"
ON roles FOR INSERT
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM user_roles ur
        WHERE ur.user_id = auth.uid()  -- Directly check if the user is admin
        AND ur.role_id = (SELECT id FROM roles WHERE name = 'admin')  -- Check if user has admin role
    )
);

-- 3. Allow only admin users to update or delete roles
CREATE POLICY "Admin users can update or delete roles"
ON roles FOR UPDATE, DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM user_roles ur
        WHERE ur.user_id = auth.uid()  -- Directly check if the user is admin
        AND ur.role_id = (SELECT id FROM roles WHERE name = 'admin')  -- Check if user has admin role
    )
);

-- 4. Allow admin users to assign permissions
CREATE POLICY "Admin users can manage permissions"
ON permissions FOR INSERT, UPDATE, DELETE
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM user_roles ur
        WHERE ur.user_id = auth.uid()  -- Directly check if the user is admin
        AND ur.role_id = (SELECT id FROM roles WHERE name = 'admin')  -- Ensure the user is admin
    )
);

-- Assign the first user as an admin automatically
-- This assumes you have already inserted roles as 'admin', 'manager', 'user'
INSERT INTO user_roles (user_id, role_id, is_admin)
VALUES (
    auth.uid(), 
    (SELECT id FROM roles WHERE name = 'admin'), 
    TRUE
) 
ON CONFLICT DO NOTHING;

-- Insert default roles and permissions if they do not exist
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
