import { configureStore } from '@reduxjs/toolkit';
import dataReducer from "./slices/DataSlice";

export default configureStore({
  reducer: {
    data: dataReducer,
  }
})