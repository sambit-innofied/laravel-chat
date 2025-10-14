<?php


use App\Events\SendMessage;
use BeyondCode\LaravelWebSockets\Apps\AppProvider;
use BeyondCode\LaravelWebSockets\Dashboard\DashboardLogger;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', function (AppProvider $appProvider) {
    return view('chat-app-example', [
        "port" => env("PUSHER_PORT"),
        "host" => env("PUSHER_HOST"),
        "authEndpoint" => "api/sockets/connect",
        "logChannel" => DashboardLogger::LOG_CHANNEL_PREFIX,
        "apps" => $appProvider->all(),
    ]);
});

Route::post("/chat/send", function (Request $request) {
    $message = $request->input("message", null);
    $name = $request->input("name", "anonymous");
    $time = (new DateTime(now()))->format(DateTime::ATOM);

    if ($name == null) {
        $name = "Anonymous";
    }

    SendMessage::dispatch($name, $message, $time);
});


