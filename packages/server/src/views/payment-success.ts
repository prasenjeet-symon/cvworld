export function paymentSuccess(price: number, order_id: string, paymentID: string) {
  return `
    <!DOCTYPE html>
    <html>
      <head>
        <title>Payment Successful</title>
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
            color: #008000;
          }
    
          p {
            margin-bottom: 10px;
          }
        </style>
      </head>
    
      <body>
        <div class="container">
          <h1>Payment Successful</h1>
          <p>Thank you for your payment. Your transaction was successful.</p>
          <p>Order ID: ${order_id}</p>
          <!-- Replace YOUR_ORDER_ID with the actual order ID -->
          <p>Amount: Rs. ${price}</p>
          <!-- Replace Rs. 100.00 with the actual amount paid -->
          <p>Payment ID: ${paymentID}</p>
          <!-- Replace PAYMENT_ID with the actual payment ID -->
          <p>Date: ${new Date().toDateString()}</p>
          <!-- Replace 2023-07-17 12:34:56 with the actual payment date and time -->
          <p>Payment Status: Success</p>
          <p>
            Thank you for your purchase! If you have any questions or concerns,
            please contact our customer support. To download your resume goto Dashboard.
          </p>
        </div>
      </body>
    </html>
    `;
}
