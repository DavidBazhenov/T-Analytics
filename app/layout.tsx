import './globals.css';

export const metadata = {
  title: 'T-Analitycs',
  description: 'T-Analitycs is a management platform for your personal finances',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="font-sans bg-[#1D1D1D]">{children}</body>
    </html>
  );
}
