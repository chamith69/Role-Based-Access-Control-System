import React from 'react';
import { Outlet, Link, useNavigate } from 'react-router-dom';
import { useAuthStore } from '../lib/store';
import {
  Users,
  Settings,
  LogOut,
  LayoutDashboard,
  Shield,
} from 'lucide-react';

export default function Layout() {
  const { user, logout } = useAuthStore();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <nav className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between h-16">
            <div className="flex">
              <div className="flex-shrink-0 flex items-center">
                <Shield className="h-8 w-8 text-indigo-600" />
                <span className="ml-2 text-xl font-bold text-gray-900">
                  RBAC System
                </span>
              </div>
              <div className="hidden sm:ml-6 sm:flex sm:space-x-8">
                <Link
                  to="/"
                  className="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-900"
                >
                  <LayoutDashboard className="h-4 w-4 mr-2" />
                  Dashboard
                </Link>
                <Link
                  to="/users"
                  className="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900"
                >
                  <Users className="h-4 w-4 mr-2" />
                  Users
                </Link>
                <Link
                  to="/roles"
                  className="inline-flex items-center px-1 pt-1 text-sm font-medium text-gray-500 hover:text-gray-900"
                >
                  <Settings className="h-4 w-4 mr-2" />
                  Roles
                </Link>
              </div>
            </div>
            <div className="flex items-center">
              <span className="text-sm text-gray-500 mr-4">{user?.email}</span>
              <button
                onClick={handleLogout}
                className="inline-flex items-center px-3 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700"
              >
                <LogOut className="h-4 w-4 mr-2" />
                Logout
              </button>
            </div>
          </div>
        </div>
      </nav>

      <main className="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
        <Outlet />
      </main>
    </div>
  );
}