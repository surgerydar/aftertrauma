package uk.co.soda.aftertrauma;

// Qt
import org.qtproject.qt5.android.QtNative;


// android
import android.content.Intent;
import android.content.Context;
import android.support.v4.content.FileProvider;
import android.net.Uri;

// java
import java.lang.String;
import java.io.File;

public class FileShareDialog {

    static final String AUTHORITY = "uk.co.soda.aftertrauma.fileprovider";

    public static void share(String path, String mime) {
        System.out.println("share");
        //
        //
        //
        Context context = QtNative.activity();
        //
        // create SEND intent
        //
        Intent intent = new Intent( Intent.ACTION_SEND );
        //
        // get content provider Uri
        //
        File file = new File(path);
        Uri uri = FileProvider.getUriForFile( context, AUTHORITY, file );
        //
        // set data
        //
        //intent.setDataAndType( uri, mime );
        intent.putExtra(Intent.EXTRA_STREAM, uri);
        intent.setType(mime);
        //
        // set flags
        //
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        //
        // create chooser
        //
        Intent chooser = Intent.createChooser( intent, "Choose destination..." );
        //
        // share
        //
        context.startActivity(chooser);
    }
}
