import { create } from 'zustand';
import { supabase } from './supabase';

interface User {
  id: string;
  email: string;
  roles: string[];
}

interface AuthState {
  user: User | null;
  roles: string[];
  permissions: string[];
  setUser: (user: User | null) => void;
  setRoles: (roles: string[]) => void;
  setPermissions: (permissions: string[]) => void;
  hasPermission: (permission: string) => boolean;
  logout: () => Promise<void>;
}

export const useAuthStore = create<AuthState>((set, get) => ({
  user: null,
  roles: [],
  permissions: [],
  setUser: (user) => set({ user }),
  setRoles: (roles) => set({ roles }),
  setPermissions: (permissions) => set({ permissions }),
  hasPermission: (permission) => get().permissions.includes(permission),
  logout: async () => {
    await supabase.auth.signOut();
    set({ user: null, roles: [], permissions: [] });
  },
}));



