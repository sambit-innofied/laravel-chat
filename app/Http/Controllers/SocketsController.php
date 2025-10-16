<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use Illuminate\Broadcasting\Broadcasters\PusherBroadcaster;
use Illuminate\Http\Request;
use Pusher\Pusher;

class SocketsController{
    public function connect(Request $request){
        $broadcaster = new PusherBroadcaster(
            new Pusher(
                "staging",
                "staging",
                "staging",
                []
            )
        );

        return $broadcaster->validAuthenticationResponse($request, []);
    }
}