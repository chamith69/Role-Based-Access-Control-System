-- Allow authenticated users to read roles
DROP POLICY IF EXISTS "Allow read access to authenticated users" ON roles;
CREATE POLICY "Allow read access to authenticated users"
ON roles FOR SELECT TO authenticated
USING (true);

-- Allow only admins to insert roles
DROP POLICY IF EXISTS "Allow insert access to admin users" ON roles;
CREATE POLICY "Allow insert access to admin users"
ON roles FOR INSERT TO authenticated
WITH CHECK (is_admin(auth.uid()));

-- Allow admins to manage (update, delete) roles
DROP POLICY IF EXISTS "Allow admin to manage roles" ON roles;
CREATE POLICY "Allow admin to manage roles"
ON roles FOR UPDATE, DELETE TO authenticated
USING (is_admin(auth.uid()));
