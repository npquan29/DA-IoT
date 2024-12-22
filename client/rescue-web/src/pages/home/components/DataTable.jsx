import React from "react";
import { Empty, Table } from "antd";
import dayjs from "dayjs";

const SupportDataTable = ({
  supportData,
  showPagination,
  total,
  params,
  setParams,
}) => {
  const columns = [
    {
      title: "Vĩ độ (°)",
      dataIndex: "latitude",
      key: "latitude",
      className: "font-inter text-sm",
    },
    {
      title: "Kinh độ (°)",
      dataIndex: "longitude",
      key: "longitude",
      className: "font-inter text-sm",
    },
    {
      title: "Nhiệt độ (°C)",
      dataIndex: "temperature",
      key: "temperature",
      className: "font-inter text-sm",
    },
    {
      title: "Độ ẩm (%)",
      dataIndex: "humidity",
      key: "humidity",
      className: "font-inter text-sm",
    },
    {
      title: "Ánh sáng (lx)",
      dataIndex: "light",
      key: "light",
      className: "font-inter text-sm",
    },
    {
      title: "Áp suất (hPa)",
      dataIndex: "pressure",
      key: "pressure",
      className: "font-inter text-sm",
    },
    {
      title: "Nhịp tim (bpm)",
      dataIndex: "heartRate",
      key: "heartRate",
      className: "font-inter text-sm",
    },
    {
      title: "Nhiệt độ cơ thể (°C)",
      dataIndex: "bodyTemperature",
      key: "bodyTemperature",
      className: "font-inter text-sm",
    },
    {
      title: "ID Thiết bị",
      dataIndex: "deviceId",
      key: "deviceId",
      className: "font-inter text-sm",
    },
    {
      title: "Thời gian",
      dataIndex: "createdAt",
      key: "createdAt",
      render: (text) => dayjs(text).format("DD-MM-YYYY HH:mm:ss"), // Định dạng ngày
      className: "font-inter text-sm",
    },
  ];

  // const onChangeTable = (
  //   pagination,
  // ) => {
  //   setParams({
  //     ...params,
  //     page: pagination.current || 1,
  //     pageSize: pagination.pageSize || 50
  //   });
  // };

  return (
    <>
      {supportData.length == 0 ? (
        <Empty />
      ) : (
        <Table
          columns={columns}
          bordered
          dataSource={supportData}
          rowKey="id"
          pagination={
            showPagination
              ? {
                  total: total,
                  // current: params.page,
                  pageSize: params.pageSize,
                  showSizeChanger: true,
                  onChange: (page, pageSize) => {
                    setParams((prev) => ({ ...prev, page: page, pageSize: pageSize }));
                  },
                  onShowSizeChange: (_, size) => {
                    // setParams((prev) => ({ ...prev, pageSize: size, page: 1 }));
                    setParams({...params, pageSize: size, page: 1});
                  },
                }
              : false
          }
          scroll={showPagination && { x: 1200, y: "calc(100vh - 200px)" }}
        />
      )}
    </>
  );
};

export default SupportDataTable;
