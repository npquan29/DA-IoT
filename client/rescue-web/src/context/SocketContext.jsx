import { createContext, useContext, useEffect, useState } from "react";
import { HOST } from "../utils/constants.js";
import { io } from "socket.io-client";
import { useDispatch } from "react-redux";
import { addData } from "../redux/slices/DataSlice.js";

const SocketContext = createContext(null);

export const useSocket = () => {
  return useContext(SocketContext);
};

export const SocketProvider = ({children}) => {
    const [socket, setSocket] = useState();
    const dispatch = useDispatch();

    useEffect(() => {
        let socketSever = io(HOST);

        socketSever.on("connect", () => {
            console.log("Connected to socket server");
          });
        
        setSocket(socketSever);

        const handleReceiveNewData = (data) => {
            dispatch(addData(data));
        }

        socketSever.on("newData", handleReceiveNewData);

        return () => {
            socketSever.disconnect();
        }
    }, []);

    return (
        <SocketContext.Provider value={socket}>
            {children}
        </SocketContext.Provider>
    )
}
