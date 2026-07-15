abstract class Failure
{
final String message;
Failure(this.message);

}

 class NetworkFailure extends Failure {
 NetworkFailure(String message) : super(message);


 }

 class ServerFailure extends Failure {


  ServerFailure(String message ) : super(message);
 }