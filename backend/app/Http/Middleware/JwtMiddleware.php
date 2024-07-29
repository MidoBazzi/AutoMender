<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Mockery\Exception;
use Symfony\Component\HttpFoundation\Response;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Facades\JWTAuth;


class JwtMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        try {
            $user = JWTAuth::parseToken()->authenticate();
        } catch (\Exception $e) {
            if($e instanceof TokenInvalidException){
                return response()->json(['status' => 'Token is Invalid']);
            }
            else if($e instanceof TokenExpiredException){
                return response()->json(['status' => 'Token is Expired']);
            }
            else {
                return response()->json(['status' => 'Token is NOT Found']);
            }
        }
        // If token valid, pass the user to the next middleware or controller
        return $next($request);

    }
}
