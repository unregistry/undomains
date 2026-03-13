<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Undomains - Maintenance</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;600;700&display=swap" rel="stylesheet">

    <!-- Theme CSS -->
    <link href="{$WEB_ROOT}/templates/{$template}/assets/css/main.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #000;
            color: #fff;
        }

        .maintenance-wrapper {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .maintenance-box {
            text-align: center;
            max-width: 500px;
            width: 100%;
        }

        .logo-section {
            margin-bottom: 50px;
        }

        .logo-section img {
            max-width: 280px;
            height: auto;
        }

        .spinner-section {
            margin: 50px 0;
        }

        /* Bounce spinner animation */
        .spinner {
            width: 60px;
            height: 60px;
            position: relative;
            margin: 0 auto;
        }

        .double-bounce1, .double-bounce2 {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background-color: #D4AF37;
            opacity: 0.6;
            position: absolute;
            top: 0;
            left: 0;
            -webkit-animation: sk-bounce 2.0s infinite ease-in-out;
            animation: sk-bounce 2.0s infinite ease-in-out;
        }

        .double-bounce2 {
            -webkit-animation-delay: -1.0s;
            animation-delay: -1.0s;
        }

        @-webkit-keyframes sk-bounce {
            0%, 100% { -webkit-transform: scale(0.0) }
            50% { -webkit-transform: scale(1.0) }
        }

        @keyframes sk-bounce {
            0%, 100% { transform: scale(0.0); -webkit-transform: scale(0.0); }
            50% { transform: scale(1.0); -webkit-transform: scale(1.0); }
        }

        .message-section h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #fff;
        }

        .message-section p {
            font-size: 18px;
            color: rgba(255, 255, 255, 0.8);
            line-height: 1.6;
        }

        .footer-section {
            margin-top: 60px;
            padding-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .footer-section p {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.5);
        }

        .footer-section a {
            color: #D4AF37;
            text-decoration: none;
        }

        .footer-section a:hover {
            text-decoration: underline;
        }

        /* Light theme */
        [data-background="light"] body {
            background-color: #f5f5f5;
            color: #333;
        }

        [data-background="light"] .double-bounce1,
        [data-background="light"] .double-bounce2 {
            background-color: #D4AF37;
        }

        [data-background="light"] .message-section h1 {
            color: #333;
        }

        [data-background="light"] .message-section p {
            color: rgba(51, 51, 51, 0.8);
        }

        [data-background="light"] .footer-section {
            border-top-color: rgba(0, 0, 0, 0.1);
        }

        [data-background="light"] .footer-section p {
                color: rgba(51, 51, 51, 0.5);
        }

        @media (max-width: 480px) {
            .logo-section img {
                max-width: 200px;
            }

            .message-section h1 {
                font-size: 24px;
            }

            .message-section p {
                font-size: 16px;
            }
        }
    </style>
</head>
<body data-background="dark">
    <div class="maintenance-wrapper">
        <div class="maintenance-box">
            <!-- Logo -->
            <div class="logo-section">
                <img src="{$WEB_ROOT}/templates/{$template}/assets/img/undomains-logo-dark.png" alt="{$companyname}">
            </div>

            <!-- Spinner -->
            <div class="spinner-section">
                <div class="spinner">
                    <div class="double-bounce1"></div>
                    <div class="double-bounce2"></div>
                </div>
            </div>

            <!-- Message -->
            <div class="message-section">
                <h1>Under Maintenance</h1>
                <p>{$maintenanceMessage}</p>
            </div>

            <!-- Footer -->
            <div class="footer-section">
                <p>&copy; {$companyname}</p>
            </div>
        </div>
    </div>
</body>
</html>
