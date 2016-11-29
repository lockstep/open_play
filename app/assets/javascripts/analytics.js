$(function() {
  var ctx = $('#revenueChart');
  if (ctx.length > 0) {
    var myChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: ctx.data('bookings').dates,
        datasets: [{
          label: ctx.data('label'),
          data: ctx.data('bookings').revenues,
          backgroundColor: '#FF4571',
          borderColor: '#FF4571',
          fill: false
        }]
      },
      options: {
        responsive: true,
        hover: {
          mode: 'nearest',
          intersect: true
        },
        scales: {
          xAxes: [{
            display: true,
            scaleLabel: {
              display: true,
              labelString: 'Date'
            }
          }],
          yAxes: [{
            display: true,
            ticks: {
              beginAtZero: true
            },
            scaleLabel: {
              display: true,
              labelString: 'Revenue ($)'
            }
          }]
        }
      }
    });
  }
});
