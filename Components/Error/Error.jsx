import React from "react";

//INTERNAL IMPORT
import Style from "./Error.module.css";

const Error = ({ error }) => {
  return (
    <div className={Style.Error}>
      <div className={Style.Error_box}>
        <h2>Please Fix This Error & Reload Browser</h2>
        {error}
      </div>
    </div>
  );
};

export default Error;
