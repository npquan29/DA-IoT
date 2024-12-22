import { Navigate, Route, Routes } from "react-router-dom";
import "./App.css";
import Home from "./pages/home";
import LayoutDefault from "./components/LayoutDefault";
import HistoryData from "./pages/history";

function App() {
  return (
    <>
      <Routes>
        <Route
          path="/"
          element={
            <LayoutDefault>
              <Home />
            </LayoutDefault>
          }
        />
        
        <Route
          path="/history"
          element={
            <LayoutDefault>
              <HistoryData />
            </LayoutDefault>
          }
        />

        <Route path="*" element={<Navigate to="/" />} />
      </Routes>
    </>
  );
}

export default App;
