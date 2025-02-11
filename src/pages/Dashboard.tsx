import React from 'react';
import { useAuthStore } from '../lib/store';
import { LayoutDashboard, Users, Settings, Shield } from 'lucide-react';

export default function Dashboard() {
  const user = useAuthStore((state) => state.user);

  const stats = [
    {
      name: 'Total Users',
      value: '25',
      icon: Users,
      change: '+15.3%',
      changeType: 'positive',
    },
    {
      name: 'Active Roles',
      value: '3',
      icon: Shield,
      change: '0%',
      changeType: 'neutral',
    },
    {
      name: 'Permissions',
      value: '12',
      icon: Settings,
      change: '+3.2%',
      changeType: 'positive',
    },
  ];

  return (
    <div>
      <div className="mb-8">
        <h1 className="text-2xl font-semibold text-gray-900">Welcome back, {user?.email}</h1>
        <p className="mt-2 text-sm text-gray-600">Here's what's happening with your RBAC system today.</p>
      </div>

      <div className="grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        {stats.map((item) => (
          <div key={item.name} className="bg-white overflow-hidden shadow rounded-lg">
            <div className="p-5">
              <div className="flex items-center">
                <div className="flex-shrink-0">
                  <item.icon className="h-6 w-6 text-gray-400" />
                </div>
                <div className="ml-5 w-0 flex-1">
                  <dl>
                    <dt className="text-sm font-medium text-gray-500 truncate">{item.name}</dt>
                    <dd className="flex items-baseline">
                      <div className="text-2xl font-semibold text-gray-900">{item.value}</div>
                      <div className={`ml-2 flex items-baseline text-sm font-semibold ${
                        item.changeType === 'positive' ? 'text-green-600' : 
                        item.changeType === 'negative' ? 'text-red-600' : 'text-gray-500'
                      }`}>
                        {item.change}
                      </div>
                    </dd>
                  </dl>
                </div>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="mt-8 bg-white shadow rounded-lg">
        <div className="px-4 py-5 sm:p-6">
          <h3 className="text-lg leading-6 font-medium text-gray-900">Recent Activity</h3>
          <div className="mt-4">
            <div className="border-t border-gray-200">
              <p className="py-4 text-sm text-gray-500">No recent activity to display.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}