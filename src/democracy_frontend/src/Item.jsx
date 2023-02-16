import React, { useEffect, useState } from "react";
import {idlFactory} from "../../declarations/election";
import { Actor, HttpAgent } from "@dfinity/agent";
import {Box, Card, CardActions, CardContent, Grid, Typography} from "@mui/material";
import LoadingButton from '@mui/lab/LoadingButton';

const Item = (props) => {
  const [name, setName] = useState();
  const [options, setOptions] = useState([]);
  const [yesVote, setYesVote] = useState('');
  const [noVote, setNoVote] = useState('');

  const [loading, setLoading] = useState(false);
  const [shouldDisplay, setDisplay] = useState(false);

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

  }

  async function loadResults() {
    ElectionActor = await Actor.createActor(idlFactory,{
      agent,
      canisterId: id,
    });

    const yesCount = await ElectionActor.getYes();
    const noCount = await ElectionActor.getNo();
    setYesVote('' + yesCount);
    setNoVote('' + noCount);
  }

  useEffect(() => {
    console.log("[item] useEffect is triggered")
    loadElection();
    loadResults();
  }, []);

  async function handleVote(e, option) {
    e.preventDefault();
    setLoading(true);

    console.log(option);
    ElectionActor = await Actor.createActor(idlFactory,{
      agent,
      canisterId: id,
    });

    const vote = await ElectionActor.vote(option);
    console.log(vote);
    setLoading(false);

    if(!vote.Ok)
      return window.alert("Already voted");

    loadResults();
    return window.alert("vote registered correctly");
  }

  async function handleResults(e) {
    e.preventDefault();
    setDisplay(!shouldDisplay);
  }

  return (
    <Grid item xs={3} md={4}>
      <Card sx={{ minWidth: 225 }}>
          <CardContent>
            <Typography variant="h5" component="div">
              {name}
            </Typography>
            <Box style={{ display: shouldDisplay ? "inline" : "none" }}>
              <Typography sx={{ fontSize: 14 }} color="text.secondary" gutterBottom>
                yes = {yesVote}
              </Typography>
              <Typography sx={{ fontSize: 14 }} color="text.secondary" gutterBottom>
                no = {noVote}
              </Typography>
            </Box>
          </CardContent>
          <CardActions>
            <LoadingButton loading={loading} loadingPosition="start" size="small" onClick={event => handleVote(event, options.at(0))}>{options.at(0)}</LoadingButton>
            <LoadingButton loading={loading} loadingPosition="start" size="small" onClick={event => handleVote(event, options.at(1))}>{options.at(1)}</LoadingButton>
            <LoadingButton loading={loading} loadingPosition="start" size="small" onClick={event => handleResults(event)}> <span>{shouldDisplay ? "Hide" : "Show"} results</span> </LoadingButton>
          </CardActions>
        </Card>
    </Grid>
  );
}

export default Item;
