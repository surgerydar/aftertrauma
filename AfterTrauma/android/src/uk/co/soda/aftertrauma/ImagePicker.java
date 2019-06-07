package uk.co.soda.aftertrauma;

// Qt
import org.qtproject.qt5.android.bindings.QtApplication;
import org.qtproject.qt5.android.bindings.QtActivity;
import org.qtproject.qt5.android.QtNative;

// android
import android.content.Context;
import android.content.Intent;
import android.content.ContentResolver;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;
import android.support.v4.content.FileProvider;
import android.util.Log;

// java
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class ImagePicker {

    static final String AUTHORITY = "uk.co.soda.aftertrauma.fileprovider";

    public String getRealPathFromURI(Context context, Uri contentUri)
    {
        return getRealPathFromURI( context.getContentResolver(), contentUri);
    }

    static public String getRealPathFromURI(ContentResolver contentResolver, Uri contentUri) {
        Cursor cursor = null;
        try {
            String[] proj = { MediaStore.Images.Media.DATA };
            cursor = contentResolver.query(contentUri,  proj, null, null, null);
            int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
            cursor.moveToFirst();
            return cursor.getString(column_index);
        } finally  {
            if (cursor != null) {
                cursor.close();
            }
        }
    }
    //
    //
    //
    public static String mCurrentPhotoPath;
    //
    //
    //
    private static File getImageFile() {
        Context context = QtNative.activity();
        File imagePath = new File(context.getFilesDir(), "aftertrauma");
        File newFile = new File(imagePath, "default_image.jpg");
        if (newFile.exists()) {
          newFile.delete();
        } else {
          newFile.getParentFile().mkdirs();
        }
        return newFile;
    }

    private static Uri getOutputMediaFileUri() {
        return FileProvider.getUriForFile(QtNative.activity(),AUTHORITY,getImageFile());
    }
    //
    //
    //
    public static Intent openCamera() {
        Log.d("ImagePicker.openCamera", "Creating intent ..." );
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        Log.d("ImagePicker.openCamera", "Creating output file ..." );
        Uri fileUri = getOutputMediaFileUri(); // create a file to save the image
        if ( fileUri != null ) {
            mCurrentPhotoPath = fileUri.toString();
            Log.d("ImagePicker.openCamera", "Setting output uri : " + mCurrentPhotoPath );
            intent.putExtra(MediaStore.EXTRA_OUTPUT, fileUri); // set the image file name
            intent.addFlags(Intent.FLAG_GRANT_WRITE_URI_PERMISSION);
            return intent;
        } else {
            Log.d("ImagePicker.openCamera", "null fileUri" );
        }
        return null;
    }
    //
    //
    //
    public static Intent openGallery() {
        Log.d("ImagePicker.openGallery", "creating intent" );
        Intent intent = new Intent(Intent.ACTION_GET_CONTENT);
        intent.setType("image/*");
        return intent;
    }
}
