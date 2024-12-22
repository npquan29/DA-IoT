import React, { useEffect, useState } from 'react'
import { useDispatch, useSelector } from 'react-redux';
import { apiClient } from '../../lib/api-client';
import { DATA_ROUTES } from "../../utils/constants.js";
import { setData } from '../../redux/slices/DataSlice.js';
import SupportDataTable from './components/DataTable.jsx';
import { Link } from "react-router-dom";

const Home = () => {

  const supportData = useSelector((state) => state.data.value);

  return (
    <div className='p-5 pb-0'>
      <h1 className='text-3xl text-center font-inter font-bold mb-4'>Disaster Parameter Monitoring</h1>
      <SupportDataTable supportData={supportData} showPagination={false} />
    </div>
  )
};

export default Home;