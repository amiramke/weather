document.addEventListener('DOMContentLoaded', () => {
  const submitButton = document.querySelector('#submit');
  const addressInput = document.querySelector('#address');

  addressInput.addEventListener('keyup', event => {
    if (event.key === 'Enter') {
      submitButton.click();
    }
  });

  submitButton.addEventListener('click', () => {
    const address = document.querySelector('#address').value;
    fetch('/api/weather', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ address: address })
    })
      .then(response => {
        if (response.status >= 300) {
          throw new Error(response.error);
        }
        return response.json();
      })
      .then(data => {
        document.querySelector("#daily-forecast").innerHTML =
          "<p class='text-center'>Temperature: " + data.temperature + "°F, Windspeed: " + data.windspeed + ", Cached: " + data.cache_hit + "</p>";

        const forecastData = data.weekly_forecast;
        const forecastTable = document.getElementById("forecast-table");
        const forecastTableData = document.getElementById("forecast-data");

        for (let date in forecastData) {
          const lowTemp = forecastData[date][0];
          const highTemp = forecastData[date][1];

          const row = document.createElement("tr");
          const dateCell = document.createElement("td");
          const lowTempCell = document.createElement("td");
          const highTempCell = document.createElement("td");

          dateCell.textContent = date;
          lowTempCell.textContent = lowTemp;
          highTempCell.textContent = highTemp;

          row.appendChild(dateCell);
          row.appendChild(lowTempCell);
          row.appendChild(highTempCell);

          forecastTableData.appendChild(row);
        }

        forecastTable.style.display = "table";
      })
      .catch(error => {
        console.error(error);
        alert('An error occurred while fetching the weather information. Please try again later.');
      });
  });
});
