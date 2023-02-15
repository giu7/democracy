import React, { useEffect, useState } from "react";
import {idlFactory} from "../../declarations/election";
import { Actor, HttpAgent } from "@dfinity/agent";
import { election } from "../../declarations/election";
import {Card, CardActions, CardContent, Grid, Typography} from "@mui/material";
import Button from "@mui/material/Button";

const Item = (props) => {
  const [name, setName] = useState();
  const [options, setOptions] = useState([]);

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

    const yesCount = await ElectionActor.getYes();
    console.log(name, ' yes: ', yesCount)
    const noCount = await ElectionActor.getNo();
    console.log(name, ' no: ', noCount)

    //setName(name);
    setName(name + ': yes = ' + yesCount + '; no = ' + noCount)
    setOptions(options);
    console.log(options);
  }

  useEffect(() => {
    console.log("[item] useEffect is triggered")
    loadElection();
  }, []);

  async function handleVote(e, option) {
    e.preventDefault();
    console.log(option);
    ElectionActor = await Actor.createActor(idlFactory,{
      agent,
      canisterId: id,
    });

    const vote = await ElectionActor.vote(option);
    console.log(vote);
  }

  return (
    <Grid item xs={3} md={4}>
      <Card sx={{ minWidth: 225 }}>
          <CardContent>
            <Typography sx={{ fontSize: 14 }} color="text.secondary" gutterBottom>
              label
            </Typography>
            <Typography variant="h5" component="div">
              {name}
            </Typography>
          </CardContent>
          <CardActions>
            <Button size="small" onClick={event => handleVote(event, options.at(0))}>{options.at(0)}</Button>
            <Button size="small" onClick={event => handleVote(event, options.at(1))}>{options.at(1)}</Button>
          </CardActions>
        </Card>
    </Grid>
  );
}

export default Item;
