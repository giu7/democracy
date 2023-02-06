import React, { useEffect, useState } from "react";
import Item from "./Item";
const Board = (props) => {
  const [items, setItems] = useState();

  function fetchAllElections() {
    if(props.ids != undefined){
      setItems(
        props.ids.map((ElectionId) => (
          <Item id={ElectionId} key={ElectionId.toText()} />
        ))
      );
    }
  }

  useEffect(() => {
    console.log("[board] useEffect is triggered")
    fetchAllElections();
  }, []);


  return (
    <fieldset>
      <legend>{props.title}</legend>
      <ul>{items}</ul>
    </fieldset>
  )

}

export default Board;
