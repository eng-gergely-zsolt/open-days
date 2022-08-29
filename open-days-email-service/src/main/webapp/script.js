$.post('http://localhost:8081/open-days/users/password-reset', JSON.stringify(dataPayload))
                .done(function (response) {
                    document.getElementById("password_one").value="";
                    document.getElementById("password_two").value="";

                    if ($(response).attr("operationResult") === "SUCCESS") {
                        $("#not-successful-result").attr("style", "display: none !important;");
                        $("#successful-result").attr("style", "display: block !important;");
                    } else {
                        $("#successful-result").attr("style", "display: none !important;");
                        $("#not-successful-result").attr("style", "display: block !important;");
                    }
                });



                $.ajax({
                                type: "POST",
                                crossDomain: true,
                                data: "token=tokenValue&password=password_one",
                                url: "http://localhost:8081/open-days/users/password-reset",
                                headers: {
                                    "Access-Control-Allow-Origin": "*",
                                    "Access-Control-Allow-Methods": "POST",
                                    "Access-Control-Allow-Headers": "application/json",
                                    "Access-Control-Max-Age": 86400
                                },
                                success: function (data) {
                                    alert("YEY");
                                },
                                error: function (err) {
                                    alert("NOPE");
                                }
                            });