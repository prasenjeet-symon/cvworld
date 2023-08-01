import { getBaseUrl, getResourcePath } from "../utils"

export function buyTemplate(imageUrl: string, price : number, orderId: string, fullName: string, mobileNumber: string, email: string, hostName: string) {
  return `
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta http-equiv="X-UA-Compatible" content="ie=edge" />
        <!-- Include the Razorpay script -->
        <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
        <title>Buy Now</title>
        <style>
          * {
            padding: 0px;
            margin: 0px;
          }
    
          .cvWorldBuyTemplate {
            margin: 10px auto;
            width: 30%;
            background-color: aliceblue;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 25px;
          }
    
          .cvWorldBuyTemplate img {
            width: 100%;
            height: auto;
            object-fit: cover;
            object-position: center center;
          }
    
          .cvWorldBuyTemplate > div {
            width: 100%;
            display: flex;
            align-items: center;
            justify-content: space-between;
          }
    
          .cvWorldBuyTemplate > div > div:nth-of-type(1) {
            flex: 1;
          }
    
          .cvWorldBuyTemplate > div > div:nth-of-type(2) button {
            padding: 15px 45px;
            background-color: blue;
            color: white;
            font-weight: 600;
            font-size: 1.1rem;
            margin: 15px 0px 0px 0px;
            outline: none;
            border: 0px;
            cursor: pointer;
          }
    
          @media (max-width: 780px) {
            .cvWorldBuyTemplate {
              width: 100%;
              margin: 0 auto;
            }
          }
        </style>
      </head>
      <body>
        <section class="cvWorldBuyTemplate">
          <img
            src="${hostName + imageUrl}"
          />
          <div>
            <div></div>
            <div><button id="rzp-button" type="button">Buy Now</button></div>
          </div>
        </section>
      </body>

      <script>
        // Razorpay configuration
        const options = {
            "key": "${process.env.RAZORPAY_KEY_ID || ''}", // Replace this with your actual Razorpay API key
            "amount": ${price}, // Replace this with the amount in paisa (e.g., 10000 paisa = Rs. 100)
            "currency": "INR",
            "name": "CV WORLD",
            "description": "Buy Template",
            "image": "${hostName}logo.png", // Replace this with your company logo URL
            "order_id": "${orderId}", // Replace this with your actual order ID
            "handler": function (response) {
                // This function will be called after successful payment
                console.log("Payment successful!", response);
                // redirect to success page
                const {razorpay_payment_id, razorpay_order_id, razorpay_signature } = response;
                const URL = "${hostName}" + "server/api_public/payment_success?razorpay_payment_id=" + razorpay_payment_id + "&razorpay_order_id=" + razorpay_order_id + "&razorpay_signature=" + razorpay_signature + "&price=" + ${price};
                window.location.href = URL;
            },
            "prefill": {
                "name": "${fullName}",
                "email": "${email}",
                "contact": "${mobileNumber}"
            },
            "theme": {
                "color": "#0F07FB" // Replace this with your desired color code
            }
        };

        // Create a Razorpay instance
        const rzp = new Razorpay(options);

        // Add event listener to the payment button
        document.getElementById('rzp-button').onclick = function () {
            rzp.open();
        };
    </script>
    </html>
    `;
}
