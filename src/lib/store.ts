import { create } from 'zustand';

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
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  roles: [],
  permissions: [],
  setUser: (user) => set({ user }),
  setRoles: (roles) => set({ roles }),
  setPermissions: (permissions) => set({ permissions }),
}));

