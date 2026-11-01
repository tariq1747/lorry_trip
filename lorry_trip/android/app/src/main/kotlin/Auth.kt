import android.os.Bundle
import androidx.activity.ComponentActivity // Changed from android.app.Activity
import androidx.activity.compose.setContent // Required for Compose
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier

class Auth : ComponentActivity() { // Must extend ComponentActivity
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Use setContent {} instead of setContentView()
        setContent {
            AuthScreen()
        }
    }

    // Capitalized @Composable
    @Composable
    fun AuthScreen() {
        
        // Capitalized Column
        Column( 
            modifier = Modifier.fillMaxSize(),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text(text = "This is the Auth Screen")
            Button(onClick = {
                // Handle button click
            }) {
                Text(text = "Click Me")
            }
        }
    }
}