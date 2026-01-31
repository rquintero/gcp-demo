import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  serverExternalPackages: [],
  turbopack: {
    root: process.cwd(),
  },
};

export default nextConfig;
