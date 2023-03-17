


// define the time limit
let TIME_LIMIT = 40;

// define quotes to be used
let quotes_array = [
    "Push yourself, because no one else is going to do it for you.",
    "Failure is the condiment that gives success its flavor.",
    "Wake up with determination. Go to bed with satisfaction.",
    "It's going to be hard, but hard does not mean impossible.",
    "Learning never exhausts the mind.",
    "The only way to do great work is to love what you do."
];


// selecting required elements
let timer_text = document.querySelectorAll(".curr_time");
let accuracy_text = document.querySelectorAll(".curr_accuracy");
let error_text = document.querySelectorAll(".curr_errors");
let cpm_text = document.querySelectorAll(".curr_cpm");
let wpm_text = document.querySelectorAll(".curr_wpm");
let quote_text = document.querySelector(".quote");
let input_area = document.querySelector(".input_area");
let restart_btn = document.querySelector(".restart_btn");
let startbtn = document.querySelector(".startbtn");

let cpm_group = document.querySelector(".cpm");
let wpm_group = document.querySelector(".wpm");
let error_group = document.querySelector(".errors");
let accuracy_group = document.querySelector(".accuracy");
let car = document.querySelector(".car");
var restrictedKeys = ["Alt","Ctrl",""]

let timeLeft = TIME_LIMIT;
let timeElapsed = 0;
let total_errors = 0;
let errors = 0;
let accuracy = 0;
let characterTyped = 0;
let current_quote = "";
let quoteNo =0;
let timer = null;
var Correct_letters = 0;
var car_width = 800 * 0.19;
var finishing_line = 800 * 0.08
var track_total_distance = 800 -(finishing_line + car_width);
var status = "";
var carspeedperword = 0;
var carspeed = 0;

const DifficultyLevel = {
    easy:false,
    Hard:false
}


const cars = [
    {
        id : 0,
        carname:"Car1",
        carImage:"../Images/blackcar.png",
        Status:false

    },
    {
        id:1,
        carname:"Car2",
        carImage:"../images/bluecar.png",
        Status:false

    },
    {
        id:2,
        carname:"Car3",
        carImage:"../images/YellowCar.png",
        Status:false

    }
];

// console.log(track_total_distance+"car distance"+" type "+typeof(track_total_distance))



function selectCar() {

    
    $("#ChooseCar").modal('show');

   $(".btn").click(function(){
        var radioValue = $("input[name='Cars']:checked").val();
        var Difficultylevel = $("input[name='difficulty']:checked").val();
        if (radioValue) {
            if (Difficultylevel) {
            var SelectCar = cars[radioValue].carImage;
            $(car).css({"background-image": "url(" + SelectCar + ")"});
            $("#ChooseCar").modal("hide");
            $(input_area).focus();
            startGame();
            if (Difficultylevel == "hard") {
                carspeedperword = 4;
            }
            else {
                carspeedperword =8;
            }
        }
            else {
                alert("Please select difficulty level");
        }
            
        }
        else{
            alert("please select car")
        }
    });

}
    
function updateQuote() {

    quote_text.textContent = null;
    
    current_quote = quotes_array[quoteNo];
    
    // Saare characters ko separate krdo
    // style krne ke liye
    current_quote.split('').forEach(char => {
        const charSpan = document.createElement('span')
        charSpan.innerText = char
        quote_text.appendChild(charSpan)
    })
    
    // roll over krdo pahle quote ko
    if (quoteNo < quotes_array.length - 1)
        quoteNo++;
    else
        quoteNo = 0;
}

function processCurrentText() {


        if (carspeed >= track_total_distance) {
            // alert("")
            //track distance khatam race end 
            finishGame();
        }
        else {


            // get current input text and split it
            curr_input = input_area.value;
            curr_input_array = curr_input.split('');

            // increment total characters typed


            characterTyped++;
            errors = 0;

            quoteSpanArray = quote_text.querySelectorAll('span');
            quoteSpanArray.forEach((char, index) => {
                let typedChar = curr_input_array[index];

                // character not currently typed
                if (typedChar == null) {
                    char.classList.remove('correct_char');
                    char.classList.remove('incorrect_char');

                    // correct character
                } else if (typedChar === char.innerText) {
                    char.classList.add('correct_char');
                    char.classList.remove('incorrect_char');
                    status = "Correct";
                }
                    // incorrect character
                else {

                    status = "Incorrect";

                    char.classList.add('incorrect_char');
                    char.classList.remove('correct_char');

                    // increment number of errors
                    errors++;
                }

            });

            input_area.onkeydown = function (event) {
                var key = event.key;
                console.log(status)
                if (status == "Correct" && key != "Backspace") {
                    // console.log('charatertyped: ', characterTyped , 'errors: ', errors )



                    carspeed += carspeedperword;
                    //Correct_letters = (characterTyped - errors) + carspeed;
                    $(car).animate({ "left": carspeed + "px" }, "fast");
                }
                else if(status == "Incorrect"){
                    return 0;
                }
                else {
                    if ( input_area.value == "") {
                        return 0;
                    }
                    else {
                    carspeed -= carspeedperword;
                    $(car).animate({ "left": carspeed + "px" }, "fast");
                    }


                }

            }

             //display the number of errors
            error_text[0].textContent = total_errors + errors;
            error_text[1].textContent = total_errors + errors;
            error_text[2].textContent = total_errors + errors;

            // update accuracy text
            let correctCharacters = (characterTyped - (total_errors + errors));
            let accuracyVal = ((correctCharacters / characterTyped) * 100);
            accuracy_text[0].textContent = Math.round(accuracyVal);
            accuracy_text[1].textContent = Math.round(accuracyVal);
            accuracy_text[2].textContent = Math.round(accuracyVal);


            // if current text is completely typed
            // irrespective of errors
            if (curr_input.length == current_quote.length) {
                updateQuote();

                // update total errors
                total_errors += errors;

                // clear the input area
                input_area.value = "";
            }
        }
  
}

function startGame() {
    $("#Loser").modal("hide");
    input_area.disabled = false;

    newFunction();
    updateQuote();

    // clear old and start a new timer
    clearInterval(timer);
    timer = setInterval(updateTimer, 1000);

    function newFunction() {
        resetValues();
    }
}

function resetValues() {
    $('#Loser').modal('hide');
    $('#Winner').modal('hide');
    //transform quote_text into lowercase
    $(quote_text).css("text-transform", "none");

    timeLeft = TIME_LIMIT;
    timeElapsed = 0;
    errors = 0;
    total_errors = 0;
    accuracy = 0;
    characterTyped = 0;
    quoteNo = 0;
    input_area.disabled = false;
    carspeedperword = 0;
    input_area.value = "";
    quote_text.textContent = 'Click on the area below to start the game.';
    //accuracy_text.textContent = 100;
    $.each(accuracy, (key,value) => {
        value.textContent = 100
    })
    timer_text[0].textContent = timeLeft + 's';
    timer_text[1].textContent = timeLeft + 's';
    timer_text[2].textContent = timeLeft + 's';

    error_text[0].textContent = 0;
    error_text[1].textContent = 0;
    error_text[2].textContent = 0;

    cpm_group.style.display = "none";
    wpm_group.style.display = "none";

    carspeed = 0;
    $(car).css("left", "0px");
  
}

function updateTimer() {
    if (timeLeft > 0) {
        
        // alert('here ')
        // decrease the current time left
        timeLeft--;

        // increase the time elapsed
        timeElapsed++;

        // update the timer text
        timer_text[0].textContent = timeLeft + "s";
        timer_text[1].textContent = timeLeft + 's';
        timer_text[2].textContent = timeLeft + 's';

    }
    else {
        // finish the game
        finishGame();
    }
}

function finishGame() {
    // stop the timer
    clearInterval(timer);

    // disable the input area
    input_area.disabled = true;

    // show finishing text
    quote_text.textContent = "Click on restart to start a new game.";

    // display restart button
    restart_btn.style.display = "block";

    // calculate cpm and wpm
    cpm = Math.round(((characterTyped / timeElapsed)*60));
    wpm = Math.round(((characterTyped / 5) / timeElapsed)*60);

    // update cpm and wpm text
   
    cpm_text[0].textContent = cpm;
    wpm_text[0].textContent = wpm;

    // display the cpm and wpm
    cpm_group.style.display = "block";
    wpm_group.style.display = "block";
    
    //transform text into uppercase
    $(quote_text).css("text-transform", "uppercase");


    if (timeLeft != 0) {
        
        accuracy = accuracy_text[0].textContent;
        SendData(cpm, wpm, accuracy, timeLeft);
        $("#Winner").modal("show");
    }
    else {
        $("#Loser").modal("show");
        }




}

function SendData(cpm, wpm, accuracy, timeElapsed) {
    var playerid = $('#id');
    
    var score = { wpm: wpm, cpm: cpm, Aquracy: accuracy, timeelapsed: timeElapsed, PlayerId: playerid.val() };
    $.post("/Home/check/", {score:score} , (data) => {
        $.each(data, (key,item) => {
            console.log(item.player.Player_name);

        })
    });

}


