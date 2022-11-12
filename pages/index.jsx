import React, { useEffect, useState, useContext } from "react";

//INTERNAL IMPORT
// import { ChatAppContect } from "../Context/ChatAppContext";
import Filter from "../Components/Filter/Filter";
import Friend from "../Components/Friend/Friend";
const ChatApp = () => {
  // const {} = useContext(ChatAppContect);
  return (
    <div>
      <Filter />
      <Friend />
    </div>
  );
};

export default ChatApp;
