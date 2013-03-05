/*global d3:true*/
// Data generator
var t = 1297110663, // start time (seconds since epoch)
   v = 70; // start value (subscribers)
   //data = d3.range(33).map(next); // starting dataset



var w = 20,
  h = 80;

function next() {
 return {
   time: ++t,
   value: v = ~~Math.max(10, Math.min(90, v + 10 * (Math.random() - 0.5)))
 };
}

var data = [];
for(var i=0; i<10; i++) {
  var row=[];
  for(var j=0; j<20; j++)
    row.push(next());
  data.push(row);
}

function flatten(data) {
  var flat = [];
  for(var i=0; i<10; i++) {
    var row = data[i];
    for(var j=0; j<20; j++)
      flat.push(row[j]);
  }
  return flat;
}

var flat = flatten(data);


function nest(flat, data) {
  for(var i=0; i<10; i++) {
    var row = data[i];
    for(j=0; j<20; j++)
      row[j] = flat[i*20+j];
  }
}

console.log("flat", flat)
console.log("data", data)


var x = d3.scale.linear()
  .domain([0, 1])
  .range([0, w]);

var y = d3.scale.linear()
  .domain([0, 100])
  .rangeRound([0, h]);

var chart = d3.select("body").append("svg")
  .attr("class", "chart")
  .attr("width", w * data.length - 1)
  .attr("height", h);

var rows = chart.selectAll("g")
  .data(data)
.enter().append("g")

var rect = rows.selectAll("g")
  .data(function (d,i) {return d;})
.enter().append("rect")
  .attr("x", function(d, i) { return x(i) - 0.5; })
  .attr("y", function(d) { return h - y(d.value) - 0.5; })
  .attr("width", w)
  .attr("height", function(d) { return y(d.value); });

// y-axis
chart.append("line")
  .attr("x1", 0)
  .attr("x2", w * data.length)
  .attr("y1", h - 0.5)
  .attr("y2", h - 0.5)
  .style("stroke", "#000");


 function redraw() {

  // Update…
  chart.selectAll("rect")
    .data(data)
  //.transition()
  //  .duration(1000)
    .attr("y", function(d) { return h - y(d.value) - 0.5; })
    .attr("height", function(d) { return y(d.value); });
 
 }


// Async Data update
setInterval(function() {
 flat.shift();
 flat.push(next());
 nest(flat, data);
 redraw();
}, 1500);


