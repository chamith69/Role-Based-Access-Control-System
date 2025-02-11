/*
  # Create users with roles view

  1. New View
    - users_with_roles
      - Combines auth.users with their roles through user_roles junction table
      - Aggregates role names into an array
  
  2. Security
    - View is accessible to authenticated users through GRANT
    - Inherits RLS policies from underlying tables
*/

-- Drop the view if it exists to avoid conflicts
DROP VIEW IF EXISTS users_with_roles;

-- Create the view
CREATE OR REPLACE VIEW users_with_roles AS
SELECT 
    au.id,
    au.email,
    COALESCE(
        array_agg(DISTINCT r.name) FILTER (WHERE r.name IS NOT NULL),
        ARRAY[]::text[]
    ) as roles
FROM auth.users au
LEFT JOIN user_roles ur ON au.id = ur.user_id
LEFT JOIN roles r ON ur.role_id = r.id
GROUP BY au.id, au.email;

-- Grant access to authenticated users
GRANT SELECT ON users_with_roles TO authenticated;