//ws_server.js
var WebSocketServer = require('ws').Server;
var uuid = require("node-uuid");
var moment = require('moment');
moment.locale('zh-cn');

const wss = new WebSocketServer({ port: 3001 });

//scan client id
var clientStocks = [];
var clientCount = 0;
var ws_scan = []; //save scan client info
var scan_status = 0;  //save scan status

function client_connect(ws)
{
  console.log('has a new websocket client, clientnum = '+clientCount);
  var client_uuid = uuid.v4();
  clientStocks.push({"clientnum":clientCount,"ws":ws,"id":client_uuid,"mode":"client"});//"ws":ws,
  console.log(clientStocks[clientCount].id+clientStocks[clientCount].mode);
  ws.send("This is client"+clientCount+", id: "+client_uuid);

  clientCount += 1;
}

function get_ws_clientcount(ws)
{
  for(var i = 0; i < clientCount; i++)//clientStocks.length
  {
    if(clientStocks[i].ws == ws)
    {
      return i;
    }
  }

}

function set_scan(ws)
{
  console.log("this is scan");
  for(var i = 0; i < clientCount; i++)//clientStocks.length
  {
    if(clientStocks[i].ws == ws)
    {
      console.log("set ws node scan");
      clientStocks[i].mode = "scan";
      ws_scan = clientStocks[i];  //save scan client
      //console.log(ws_scan);
      //ws_scan_ws=clientStocks[i].clientnum;
      scan_status = 1;
    }
  }
}

wss.on('connection', function connection(ws) {
  client_connect(ws);
  //console.log(new Date());
  ws.on('message', function message(data) {
    console.log('received: %s', data);
    ws.send('*server has get '+data);
    // judge get ws message, if data has scan,change mode
    if(data == "mode=scan" )
    {
      set_scan(ws);
    }
    //send data to scan
    if(scan_status == 1)
    {
      //console.log('ws_scan_ws: %s', ws_scan_ws);
      //temp_ws = clientStocks[ws_scan_ws].ws;
      //console.log(temp_ws);
      //temp_ws.send(">"+data);  //o
            //

      //send other client info
      ws_scan.ws.send((moment().format('h:mm:ss'))+" >[client"+clientStocks[get_ws_clientcount(ws)].clientnum+']: '+data);
      //ws.send(data);
      //console.log('typeof data is '+typeof data+' : '+data);
      //console.log('typeof data is '+typeof data.value+' : '+data.value);
    }
  });
  //ws.on("text",function ws_client_text(str)
  //{
  //  console.log("Received "+str);
  //  if(scan_status == 1)
  // {
  //     ws_scan.ws.send("> client"+clientStocks[get_ws_clientcount(ws)].clientnum+": "+str);
  //  }
  //});
});

