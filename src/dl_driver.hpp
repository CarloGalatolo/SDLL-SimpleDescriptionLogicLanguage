#ifndef __DLDRIVER_HPP__
#define __DLDRIVER_HPP__ 1

#include <string>
#include <cstddef>
#include <istream>

#include "dl_scanner.hpp"
#include "../parser.tab.hh"
#include "../location.hh"

namespace DL{

class DL_Driver{
public:
   DL_Driver() = default;

   virtual ~DL_Driver();
   
   /** 
    * parse - parse from a file
    * @param filename - valid string with input file
    */
   void parse( const char *filename );
   /** 
    * parse - parse from a c++ input stream
    * @param is - std::istream&, valid input stream
    */
   void parse( std::istream &iss );

   void critical_error (/*const DL::DL_Parser::location_type&,*/const std::string&);
   void soft_error (const std::string&);

private:
   void parse_helper( std::istream &stream );

   DL::DL_Parser  *parser  = nullptr;
   DL::DL_Scanner *scanner = nullptr;
   
   /** define some pretty colors **/
   const std::string red   = "\033[1;31m";
   const std::string blue  = "\033[1;36m";
   const std::string norm  = "\033[0m";
};

} /* end namespace DL */

#endif /* END __DLDRIVER_HPP__ */