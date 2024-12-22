import { createSlice } from "@reduxjs/toolkit";

export const DataSlice = createSlice({
  name: "data",
  initialState: {
    value: [],
    maxLength: 10
  },
  reducers: {
    setData: (state, action) => {
        state.value = action.payload;
    },
    addData: (state, action) => {
      if(state.value.length === state.maxLength) {
        state.value.pop();
      }
      state.value.unshift(action.payload);
    }
  },
});

// Action creators are generated for each case reducer function
export const { setData, addData } = DataSlice.actions;

export default DataSlice.reducer;
