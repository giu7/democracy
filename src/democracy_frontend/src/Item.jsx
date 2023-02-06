import React, { useEffect, useState } from "react";
import {idlFactory} from "../../declarations/election";
import { Actor, HttpAgent } from "@dfinity/agent";

const Item = (props) => {
  const [name, setName] = useState();
  const [options, setOptions] = useState();
  const [option1, setOption1] = useState();
  const [option2, setOption2] = useState();

  const id = props.id;

  const localHost = "http://localhost:8080/";
  const agent = new HttpAgent({ host: localHost });

  //TODO: When deploy live, remove the following line.
  agent.fetchRootKey();
  let ElectionActor;

  async function loadElection() {
    ElectionActor = await Actor.createActor(idlFactory,{
      agent,
      canisterId: id,
      });

    const name = await ElectionActor.getName();
    const options = await ElectionActor.getOptions();

    setName(name);
    setOptions(options);
    console.log(options);
  }


  useEffect(() => {
    console.log("[item] useEffect is triggered")
    loadElection();
  }, []);


  return (
    <li>
      {name} - <button>{options}</button> | <button>{options}</button>
    </li>
  );
}

export default Item;
