package android;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.R;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;

public class LocalNotify extends CordovaPlugin {
    private static String appState = "foreground";

    NotificationManager notificationManager;
    Notification note;
    PendingIntent contentIntent;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext context)
    {
        PluginResult.Status status = PluginResult.Status.OK;
        notificationManager = (NotificationManager) this.cordova.getActivity().getApplicationContext().getSystemService(Context.NOTIFICATION_SERVICE);
        JSONObject result = new JSONObject();
       
        try {
            if (action.equals("notice")) {
                this.createStatusBarNotification(args.getLong(0), args.getString(1), args.getString(2), args.getString(3), args.getString(4), args.getString(5), args.getInt(6));
                result.put("appState", appState);
                result.put("notificationId", args.getString(5));
                context.sendPluginResult(new PluginResult(status, result));
            } else if (action.equals("cancel")) {
                this.cancelNotification(args.getString(0));
                context.sendPluginResult(new PluginResult(status, result));
            } else if(action.equals("setBadgeNumber") && this.note != null) {
                note.number = args.getInt(0);
            } else if(action.equals("cancelAll")) {
                notificationManager.cancelAll();
                context.sendPluginResult(new PluginResult(status, result));
            }
            return true;
        } catch(JSONException e) {
            context.sendPluginResult(new PluginResult(PluginResult.Status.JSON_EXCEPTION));
            return false;
        }
    }

    private void createStatusBarNotification(Long fireDate, String contentText, String action, String repeatInterval, String soundName, String notificationId, Integer badge)
    {
        Context ctx = this.cordova.getActivity().getApplicationContext();
        Intent notificationIntent = new Intent(ctx, this.cordova.getActivity().getClass());
        
        notificationIntent.setAction(Intent.ACTION_MAIN);
        notificationIntent = notificationIntent.setFlags(Intent.FLAG_ACTIVITY_RESET_TASK_IF_NEEDED);
        contentIntent = PendingIntent.getActivity(ctx, 0, notificationIntent, 0);

        note = new Notification.Builder(ctx).setContentTitle(ctx.getString(ctx.getApplicationInfo().labelRes))
                        .setContentText(contentText)
                        .setSmallIcon(R.drawable.btn_star_big_on)
                        .setContentIntent(contentIntent)
                        .setAutoCancel(true)
                        .setSound(soundName!=null?Uri.parse(soundName):null)
                        .setNumber(badge)
                        .setWhen(fireDate)
                        .getNotification();

        notificationManager.notify(notificationId,0,note);
    }

    private void cancelNotification(String notificationId)
    {
        notificationManager.cancel(notificationId,0);
    }

    @Override
    public void onPause(boolean multitasking)
    {
        appState = "background";
    }

    @Override
    public void onResume(boolean multitasking)
    {
        appState = "foreground";
    }
}
