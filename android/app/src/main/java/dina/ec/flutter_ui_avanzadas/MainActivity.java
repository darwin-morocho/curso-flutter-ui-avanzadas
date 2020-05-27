package dina.ec.flutter_ui_avanzadas;

import android.content.Intent;

import androidx.annotation.NonNull;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.stripe.android.ApiResultCallback;
import com.stripe.android.PaymentConfiguration;
import com.stripe.android.PaymentIntentResult;
import com.stripe.android.Stripe;
import com.stripe.android.model.ConfirmPaymentIntentParams;
import com.stripe.android.model.PaymentIntent;
import com.stripe.android.model.PaymentMethodCreateParams;
import com.stripe.android.model.StripeIntent;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;

public class MainActivity extends FlutterActivity {

    static final String CHANNEL = "ec.dina/stripe_sdk";

    MethodChannel channel;

    MethodChannel.Result result;
    Stripe stripe;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {

        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        channel = new MethodChannel(messenger, CHANNEL);
        channel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "init":
                    String pk = call.argument("pk");
                    PaymentConfiguration.init(
                            getApplicationContext(),
                            pk
                    );
                    result.success(null);
                    break;


                case "pay":
                    this.makePay(call, result);
                    break;

                default:
                    result.notImplemented();
            }
        });


        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }


    private void makePay(MethodCall call, MethodChannel.Result result) {

        if (this.result != null) {
            result.error("PENDING_TASK", "You have a pending task", null);
            return;
        }

        this.result = result;

        String clientSecret = call.argument("clientSecret");
        String cardNumber = call.argument("cardNumber");
        String cvv = call.argument("cvv");
        int year = call.argument("year");
        int month = call.argument("month");


        PaymentMethodCreateParams.Card card = new PaymentMethodCreateParams.Card(cardNumber, month, year, cvv, null, null);
        PaymentMethodCreateParams params = PaymentMethodCreateParams.create(card);

        ConfirmPaymentIntentParams confirmPaymentIntentParams = ConfirmPaymentIntentParams.createWithPaymentMethodCreateParams(params, clientSecret);
        this.stripe = new Stripe(this, PaymentConfiguration.getInstance(this).getPublishableKey());
        this.stripe.confirmPayment(this, confirmPaymentIntentParams);


    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (this.stripe != null) {
            this.stripe.onPaymentResult(requestCode, data, new ApiResultCallback<PaymentIntentResult>() {
                @Override
                public void onSuccess(PaymentIntentResult result) {
                    PaymentIntent intent = result.getIntent();
                    StripeIntent.Status status = intent.getStatus();
                    switch (status) {
                        case Succeeded:
                            sendResult("succeeded");
                            break;
                        case Canceled:
                            sendResult("canceled");
                            break;
                        default:
                            sendResult("failed");

                    }

                }

                @Override
                public void onError(@NotNull Exception e) {
                    Log.i("StripeSDK:", e.getMessage());
                    sendResult("error");
                }
            });
        }
    }


    private void sendResult(String status) {
        HashMap<String, String> response = new HashMap<>();
        response.put("status", status);
        this.result.success(response);
        this.result = null;

    }
}
