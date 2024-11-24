import type { Config } from "tailwindcss";

export default {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        background: 'transparent',
        tinkoff: ['TinkoffSans', 'sans-serif'],
        holtwood: ['Holtwood One SC', 'serif'],
      },
    },
    screens: {
      sm: '640px',
      md: '768px',
      lg: '1024px',

      'lg-1275': '1275px',
    },
  },
  plugins: [],
} satisfies Config;
