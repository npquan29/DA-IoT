import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App.jsx';
import { BrowserRouter } from 'react-router-dom';
import { SocketProvider } from './context/SocketContext.jsx';
import store from './redux/store.js';
import { Provider } from 'react-redux'

createRoot(document.getElementById('root')).render(
  <BrowserRouter>
    <Provider store={store}>
      <SocketProvider>
        <App />
      </SocketProvider>
    </Provider>
  </BrowserRouter>
)
