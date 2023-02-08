import React, { useEffect, useState } from "react";
import Item from "./Item";
import {Grid, Stack, Typography} from "@mui/material";
import DashboardIcon from '@mui/icons-material/Dashboard';

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
    <>
      <Stack direction="row" spacing={2}>
        <DashboardIcon/>
        <Typography variant="h5" component="div">
          {props.title}
        </Typography>
      </Stack>

      <Grid container spacing={2}>
        {items}
      </Grid>
    </>
  )

}

export default Board;
