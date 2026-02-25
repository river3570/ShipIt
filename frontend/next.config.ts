import type { NextConfig } from 'next';

const nextConfig: NextConfig = {
  // Output standalone for Docker production build
  output: 'standalone',
  
  // Image optimization
  images: {
    domains: ['localhost', 'minio'],
    remotePatterns: [
      {
        protocol: 'http',
        hostname: 'localhost',
        port: '9000',
        pathname: '/shipit-dev/**',
      },
      {
        protocol: 'https',
        hostname: '*.amazonaws.com',
      },
    ],
  },

  // API rewrites (optional - for proxying API calls)
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: `${process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3001'}/:path*`,
      },
    ];
  },
};

export default nextConfig;
