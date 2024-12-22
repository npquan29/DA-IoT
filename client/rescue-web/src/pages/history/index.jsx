import React, { useEffect, useState } from 'react'
import SupportDataTable from '../home/components/DataTable';
import { apiClient } from '../../lib/api-client';
import { DATA_ROUTES } from '../../utils/constants';

const HistoryData = () => {
  const [params, setParams] = useState({
    page: 1,
    pageSize: 10
  });

  const [data, setData] = useState([]);
  const [total, setTotal] = useState(0);

  useEffect(() => {
    const getSupportData = async () => {
      try {
        const response = await apiClient.get(DATA_ROUTES, {
          params: params
        });

        setData(response.data.data);
        setTotal(response.data.total);
      } catch (error) {
        console.log(error);
      }
    }

    getSupportData();
  }, [params]);

  console.log(params);

  return (
    <div className='p-5 pb-0'>
      <div className='text-center font-inter text-3xl font-semibold mb-4'>History Report</div>
      <SupportDataTable supportData={data} showPagination={true} total={total} params={params} setParams={setParams} />
    </div>
  )
}

export default HistoryData