import { Button } from "antd";
import React from "react";
import { useLocation, useNavigate } from "react-router-dom";

const NavLink = ({title, link}) => {
  const location = useLocation();
  const isActive = location.pathname === link;
  const navigate = useNavigate();

  return (
    <Button
      type="text"
      className={
        `font-medium font-inter border-none h-10 w-full rounded ${isActive ? "!bg-white text-black" : "hover:!bg-white"}`
      }
      onClick={() => navigate(link)}
    >
      {title}
    </Button>
  );
}

const LayoutDefault = ({ children }) => {

  const ARRAY_MENU = [
    {
      title: "Home",
      link: "/",
    },
    {
      title: "History",
      link: "/history",
    },
  ];

  return (
    <div className="flex">
      <div className="bg-blue-400 h-screen w-[150px] sticky top-0 left-0">
        {ARRAY_MENU.map((item, idx) => (
            <div className="p-3 pb-0" key={idx}>
                <NavLink title={item.title} link={item.link}  />
            </div>
        ))}
      </div>

      <div className="flex-1">{children}</div>
    </div>
  );
};

export default LayoutDefault;
