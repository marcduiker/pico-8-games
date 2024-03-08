const customLinks=[
    "https://dapr.io/",
    "https://github.com/dapr/dapr",
    "https://bit.ly/dapr-discord",
    "https://marcduiker.dev/"
];
var gpio = getP8Gpio();
var unsubscribe = gpio.subscribe(function(indices) {
    window.open(customLinks[gpio[0]-1], '_blank');
});
