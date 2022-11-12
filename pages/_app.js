import "../styles/globals.css";
import { ChatAppProvider } from "../Context/ChatAppContext";
import Navbar from "../Components/Navbar/Navbar";
function MyApp({ Component, pageProps }) {
  return (
    <ChatAppProvider>
      <Navbar />
      <Component {...pageProps} />
    </ChatAppProvider>
  );
}

export default MyApp;
