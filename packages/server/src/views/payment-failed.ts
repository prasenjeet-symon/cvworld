export function paymentFailed(error: string, order_id : string) {
  return `
    <!DOCTYPE html>
    <html>
      <head>
        <title>Payment Failed</title>
        <style>
          body {
            font-family: Arial, sans-serif;
            text-align: center;
            background-color: #f2f2f2;
          }
    
          .container {
            margin-top: 100px;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 5px;
            max-width: 400px;
            margin: 0 auto;
            background-color: #fff;
          }
    
          h1 {
            color: #ff0000;
          }
    
          p {
            margin-bottom: 10px;
          }
    
          .error-message {
            color: #ff0000;
            font-weight: bold;
          }
        </style>
      </head>
    
      <body>
        <div class="container">
          <h1>Payment Failed</h1>
          <p>Unfortunately, your payment was not successful.</p>
          <p>Order ID: ${order_id}</p>
          <!-- Replace YOUR_ORDER_ID with the actual order ID -->
          <p>
            Error Message:
            <span class="error-message">${error}</span>
          </p>
          <!-- Replace the error message with the actual error message received from the payment gateway -->
          <p>
            Please try again later or contact our customer support for assistance.
          </p>
        </div>
      </body>
    </html>   
    `;
}
