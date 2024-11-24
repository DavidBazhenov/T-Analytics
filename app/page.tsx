import ArryayBlocks from "@/components/ArryayBlocks";
import Header from "@/components/Header";
import MainScreen from "@/components/MainScreen";
import StartBanner from "@/components/StartBanner";

export default function Home() {
  return (
    <main className="flex flex-col items-center justify-star">
      <Header />
      <MainScreen />
      <StartBanner />
      <ArryayBlocks />
    </main>
  );
}
