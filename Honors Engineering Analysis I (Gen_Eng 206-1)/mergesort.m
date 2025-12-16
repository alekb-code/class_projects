function s = mergesort(data, comp)
%MERGESORT  Sort the elements of the input.
%
%  s = mergesort(data, comp)
%
%  Inputs:
%    data = vector/array of values to sort
%    comp = function handle of custom comparison function
%           (optional, defaults to @le)
%
%  Output:
%    s = array the same size as data, with elements sorted
%        (in ascending order when using the default
%         comparison function)
%
%  Algorithm: recursive merge sort
%
%  See also SORT, SORTROWS.

% Honors EA1
% Homework Program 5
%
% Name: Branovacki, Alek
% Date: 10/23/2025

arguments
    data 
    comp function_handle = @le
end

if numel(data) <= 1 % already sorted if data is empty or only has one entry
    s = data;
else
    n = numel(data); % finding total number of elements in data
    mid = floor(n/2); % use floor function in case the number of elements is odd
            
    left = mergesort(data(1:mid), comp); % get the first half of data
    right = mergesort(data(mid+1:n), comp); % get the second half of data
            
    s = merge(left, right); % call the merge functions to merge the halves
            
    s = reshape(s, size(data)); % make sorted data in the original size and shape, from the assignment document
end

% This MERGE function merges sorted x,y into sorted z
    function z = merge(x, y)

        nx = numel(x); % number of elements in the first array
        ny = numel(y); % number of elements in the second array
        nz = nx + ny; % total number of elements
        
        if nx > 0 % initialize z with correct length and class
            z(nz) = x(1); % if x has elements, use it to define z's class
        else
            z(nz) = y(1); % otherwise use y
        end
        
        ix = 1; % indices for x, y, and z
        iy = 1;
        iz = 1;
        
        while ix <= nx && iy <= ny % merge x and y into z while both arrays still have elements left
            if comp(x(ix), y(iy)) % compare current elements using comp function
                z(iz) = x(ix); % place x(ix) into z
                ix = ix + 1; % move to next element in x
            else
                z(iz) = y(iy); % place y(iy) into z
                iy = iy + 1; % move to next element in y
            end
            iz = iz + 1; % move to next position in z
        end
        
        while ix <= nx % copy any remaining elements from x
            z(iz) = x(ix);
            ix = ix + 1;
            iz = iz + 1;
        end
        
        while iy <= ny % copy any remaining elements from y
            z(iz) = y(iy);
            iy = iy + 1;
            iz = iz + 1;
        end
        
    end % MERGE

end % MERGESORT

% Question 1

% mergesort(D)
% 
% ans =
% 
%      4    16    49    68    81    92    96
%     10    28    55    75    82    92    96
%     13    40    64    76    85    94    97
%     15    43    66    80    91    96    98
% 
% mergesort(D,@ge)
% 
% ans =
% 
%     98    96    91    80    66    43    15
%     97    94    85    76    64    40    13
%     96    92    82    75    55    28    10
%     96    92    81    68    49    16     4

% Question 2

% struct2table(mergesort(skyscrapers, @(a,b) a.Height_in_ft >= b.Height_in_ft))
% 
% ans =
% 
%   87×6 table
% 
%                      Name                      Height_in_ft    Height_in_m    Floors    Year            Coordinates         
%     _______________________________________    ____________    ___________    ______    ____    ____________________________
% 
%     {'Willis Tower'                       }        1451            442         108      1974    {'41°52′44″N87°38′9″W'     }
%     {'Trump International Hotel and Tower'}        1388            423          98      2009    {'41°53′20″N87°37′35″W'    }
%     {'St. Regis Chicago'                  }        1198            363         101      2020    {'41°53′13″N87°37′03″W'    }
%     {'Aon Center'                         }        1136            346          83      1973    {'41°53′7″N87°37′17″W'     }
%     {'875 North Michigan Avenue'          }        1127            344         100      1969    {'41°53′55.5″N87°37′23″W'  }
%     {'Franklin Center'                    }        1007            307          61      1989    {'41°52′49.5″N87°38′5″W'   }
%     {'Two Prudential Plaza'               }         995            303          64      1990    {'41°53′8″N87°37′22″W'     }
%     {'One Chicago East Tower'             }         973            296          78      2022    {'41°53′46.2″N87°37′43.6″W'}
%     {'311 South Wacker Drive'             }         961            293          65      1990    {'41°52′39″N87°38′8″W'     }
%     {'NEMA Chicago'                       }         896            273          76      2019    {'41°52′1″N87°37′23″W'     }
%     {'900 North Michigan'                 }         871            266          66      1989    {'41°53′59″N87°37′30″W'    }
%     {'Aqua'                               }         860            262          82      2009    {'41°53′11″N87°37′12″W'    }
%     {'Water Tower Place'                  }         860            262          74      1976    {'41°53′52.5″N87°37′20.5″W'}
%     {'Chase Tower'                        }         850            259          60      1969    {'41°52′53.5″N87°37′48″W'  }
%     {'Park Tower'                         }         844            257          67      2000    {'41°53′49.5″N87°37′30.5″W'}
%     {'One Bennett Park'                   }         837            255          69      2018    {'41°53′29″N87°36′56″W'    }
%     {'Salesforce Tower Chicago'           }         835            255          60      2023    {'41°53′15.4″N87°38′15.7″W'}
%     {'The Legacy at Millennium Park'      }         822            251          73      2010    {'41°52′53″N87°37′32″W'    }
%     {'110 North Wacker'                   }         814            248          51      2020    {'41°53′1″N87°38′15″W'     }
%     {'1000M'                              }         805            245          73      2024    {'41°52′10.6″N87°37′27.8″W'}
%     {'300 North LaSalle'                  }         784            239          60      2009    {'41°53′17.5″N87°37′59″W'  }
%     {'Three First National Plaza'         }         767            234          57      1981    {'41°52′56″N87°37′50″W'    }
%     {'Grant Thornton Tower'               }         755            230          50      1992    {'41°53′5″N87°37′50″W'     }
%     {'150 North Riverside'                }         752            229          54      2017    {'41°53′4.1″N87°38′20.6″W' }
%     {'Blue Cross Blue Shield Tower'       }         744            227          57      2010    {'41°53′5″N87°37′12″W'     }
%     {'River Point'                        }         732            223          52      2017    {'41°53′9.3″N87°38′21.8″W' }
%     {'Olympia Centre'                     }         731            223          63      1986    {'41°53′47″N87°37′24″W'    }
%     {'BMO Tower'                          }         729            222          51      2022    {'41°52′38″N87°38′26″W'    }
%     {'One Museum Park'                    }         726            221          62      2009    {'41°52′1.5″N87°37′17″W'   }
%     {'330 North Wabash'                   }         695            212          52      1973    {'41°53′19″N87°37′39″W'    }
%     {'Waldorf Astoria Chicago'            }         686            209          60      2010    {'41°53′59″N87°37′39″W'    }
%     {'111 South Wacker Drive'             }         681            208          51      2005    {'41°52′49″N87°38′10.5″W'  }
%     {'181 West Madison Street'            }         680            207          50      1990    {'41°52′53.5″N87°38′00″W'  }
%     {'71 South Wacker'                    }         679            207          48      2005    {'41°52′51″N87°38′10″W'    }
%     {'One Magnificent Mile'               }         673            205          57      1983    {'41°54′2″N87°37′29″W'     }
%     {'340 on the Park'                    }         672            205          64      2007    {'41°53′5.5″N87°37′8″W'    }
%     {'77 West Wacker Drive'               }         668            204          49      1992    {'41°53′11.5″N87°37′50″W'  }
%     {'Wolf Point East Tower'              }         668            204          60      2020    {'41°53′15.0″N87°38′12.4″W'}
%     {'One North Wacker'                   }         652            199          50      2001    {'41°52′56″N87°38′10″W'    }
%     {'Richard J. Daley Center'            }         648            198          32      1965    {'41°53′2.5″N87°37′49″W'   }
%     {'55 East Erie Street'                }         647            197          56      2003    {'41°53′38″N87°37′33″W'    }
%     {'Lake Point Tower'                   }         645            197          70      1968    {'41°53′30″N87°36′44″W'    }
%     {'River East Center'                  }         644            196          58      2001    {'41°53′29″N87°37′5.5″W'   }
%     {'Grand Plaza I'                      }         641            195          57      2003    {'41°53′31″N87°37′43″W'    }
%     {'155 North Wacker'                   }         638            195          45      2009    {'41°53′5″N87°38′11.5″W'   }
%     {'Leo Burnett Building'               }         635            194          50      1989    {'41°53′11″N87°37′45″W'    }
%     {'The Heritage at Millennium Park'    }         631            192          57      2005    {'41°53′3″N87°37′32″W'     }
%     {'OneEleven'                          }         630            192          59      2014    {'41°53′12″N87°37′52″W'    }
%     {'NBC Tower'                          }         627            191          37      1989    {'41°53′24″N87°37′16″W'    }
%     {'353 North Clark'                    }         624            190          44      2009    {'41°53′20″N87°37′48″W'    }
%     {'Essex on the Park'                  }         620            189          57      2019    {'41°52′04″N87°37′15″W'    }
%     {'Millennium Centre'                  }         610            186          58      2003    {'41°53′35″N87°37′45″W'    }
%     {'Chicago Place'                      }         608            185          49      1991    {'41°53′43″N87°37′30.5″W'  }
%     {'Chicago Board of Trade Building'    }         605            184          44      1930    {'41°52′39.5″N87°37′56″W'  }
%     {'CNA Center'                         }         601            183          44      1972    {'41°52′38″N87°37′32″W'    }
%     {'One Prudential Plaza'               }         601            183          41      1955    {'41°53′5″N87°37′24″W'     }
%     {'Heller International Building'      }         600            183          45      1992    {'41°52′51″N87°38′25″W'    }
%     {'200 West Madison'                   }         599            182          44      1982    {'41°52′56″N87°38′4″W'     }
%     {'The Grant'                          }         595            181          54      2010    {'41°52′1.5″N87°37′19″W'   }
%     {'1000 Lake Shore Plaza'              }         590            180          55      1964    {'41°54′3.5″N87°37′28″W'   }
%     {'The Clare'                          }         589            179          52      2008    {'41°53′50″N87°37′34″W'    }
%     {'Accenture Tower'                    }         588            179          42      1987    {'41°52′56″N87°38′26″W'    }
%     {'Marina City I'                      }         588            179          61      1964    {'41°53′17.5″N87°37′42.5″W'}
%     {'Marina City II'                     }         588            179          61      1964    {'41°53′16.5″N87°37′45″W'  }
%     {'Optima Signature'                   }         587            179          57      2017    {'41°53′28″N87°37′17″W'    }
%     {'Mid-Continental Plaza'              }         583            178          49      1972    {'41°52′49″N87°37′32.5″W'  }
%     {'Crain Communications Building'      }         582            177          41      1983    {'41°53′5″N87°37′30″W'     }
%     {'North Pier Apartments'              }         581            177          61      1990    {'41°53′27″N87°36′52.5″W'  }
%     {'Citadel Center'                     }         580            177          39      2003    {'41°52′47″N87°37′43″W'    }
%     {'One Chicago West Tower'             }         574            174          49      2022    {'41°53′46.2″N87°37′43.6″W'}
%     {'The Fordham'                        }         574            175          52      2003    {'41°53′43.5″N87°37′38″W'  }
%     {'190 South LaSalle Street'           }         573            175          40      1987    {'41°52′47″N87°37′58″W'    }
%     {'One South Dearborn'                 }         571            174          39      2005    {'41°52′54″N87°37′43″W'    }
%     {'Onterie Center'                     }         570            174          60      1986    {'41°53′38″N87°36′59″W'    }
%     {'Loews Hotel Tower'                  }         569            174          52      2015    {'41°53′23.9″N87°37′8″W'   }
%     {'151 North Franklin'                 }         568            173          35      2018    {'41°53′5.28″N87°38′6″W'   }
%     {'Chicago Temple Building'            }         568            173          21      1924    {'41°52′59″N87°37′50″W'    }
%     {'Palmolive Building'                 }         565            172          37      1929    {'41°53′59″N87°37′25″W'    }
%     {'Cirrus'                             }         562            171          37      2022    {'41°53′10″N87°36′55″W'    }
%     {'Kluczynski Federal Building'        }         562            171          42      1974    {'41°53′42″N87°37′47″W'    }
%     {'Boeing International Headquarters'  }         560            171          36      1990    {'41°53′2.5″N87°38′19″W'   }
%     {'Huron Plaza'                        }         560            171          56      1983    {'41°53′43″N87°37′36″W'    }
%     {'North Harbor Tower'                 }         556            169          55      1988    {'41°53′7.5″N87°36′55.5″W' }
%     {'The Parkshore'                      }         556            169          56      1991    {'41°53′8.5″N87°36′53″W'   }
%     {'Civic Opera House'                  }         555            169          45      1929    {'41°52′57″N87°38′14.5″W'  }
%     {'Atwater Apartments'                 }         554            169          55      2009    {'41°53′32″N87°37′5″W'     }
%     {'Harbor Point'                       }         554            169          54      1975    {'41°53′6″N87°36′53″W'     }

% struct2table(mergesort(skyscrapers, @(a,b) a.Year <= b.Year))
% 
% ans =
% 
%   87×6 table
% 
%                      Name                      Height_in_ft    Height_in_m    Floors    Year            Coordinates         
%     _______________________________________    ____________    ___________    ______    ____    ____________________________
% 
%     {'Chicago Temple Building'            }         568            173          21      1924    {'41°52′59″N87°37′50″W'    }
%     {'Civic Opera House'                  }         555            169          45      1929    {'41°52′57″N87°38′14.5″W'  }
%     {'Palmolive Building'                 }         565            172          37      1929    {'41°53′59″N87°37′25″W'    }
%     {'Chicago Board of Trade Building'    }         605            184          44      1930    {'41°52′39.5″N87°37′56″W'  }
%     {'One Prudential Plaza'               }         601            183          41      1955    {'41°53′5″N87°37′24″W'     }
%     {'1000 Lake Shore Plaza'              }         590            180          55      1964    {'41°54′3.5″N87°37′28″W'   }
%     {'Marina City I'                      }         588            179          61      1964    {'41°53′17.5″N87°37′42.5″W'}
%     {'Marina City II'                     }         588            179          61      1964    {'41°53′16.5″N87°37′45″W'  }
%     {'Richard J. Daley Center'            }         648            198          32      1965    {'41°53′2.5″N87°37′49″W'   }
%     {'Lake Point Tower'                   }         645            197          70      1968    {'41°53′30″N87°36′44″W'    }
%     {'875 North Michigan Avenue'          }        1127            344         100      1969    {'41°53′55.5″N87°37′23″W'  }
%     {'Chase Tower'                        }         850            259          60      1969    {'41°52′53.5″N87°37′48″W'  }
%     {'CNA Center'                         }         601            183          44      1972    {'41°52′38″N87°37′32″W'    }
%     {'Mid-Continental Plaza'              }         583            178          49      1972    {'41°52′49″N87°37′32.5″W'  }
%     {'330 North Wabash'                   }         695            212          52      1973    {'41°53′19″N87°37′39″W'    }
%     {'Aon Center'                         }        1136            346          83      1973    {'41°53′7″N87°37′17″W'     }
%     {'Kluczynski Federal Building'        }         562            171          42      1974    {'41°53′42″N87°37′47″W'    }
%     {'Willis Tower'                       }        1451            442         108      1974    {'41°52′44″N87°38′9″W'     }
%     {'Harbor Point'                       }         554            169          54      1975    {'41°53′6″N87°36′53″W'     }
%     {'Water Tower Place'                  }         860            262          74      1976    {'41°53′52.5″N87°37′20.5″W'}
%     {'Three First National Plaza'         }         767            234          57      1981    {'41°52′56″N87°37′50″W'    }
%     {'200 West Madison'                   }         599            182          44      1982    {'41°52′56″N87°38′4″W'     }
%     {'Crain Communications Building'      }         582            177          41      1983    {'41°53′5″N87°37′30″W'     }
%     {'Huron Plaza'                        }         560            171          56      1983    {'41°53′43″N87°37′36″W'    }
%     {'One Magnificent Mile'               }         673            205          57      1983    {'41°54′2″N87°37′29″W'     }
%     {'Olympia Centre'                     }         731            223          63      1986    {'41°53′47″N87°37′24″W'    }
%     {'Onterie Center'                     }         570            174          60      1986    {'41°53′38″N87°36′59″W'    }
%     {'190 South LaSalle Street'           }         573            175          40      1987    {'41°52′47″N87°37′58″W'    }
%     {'Accenture Tower'                    }         588            179          42      1987    {'41°52′56″N87°38′26″W'    }
%     {'North Harbor Tower'                 }         556            169          55      1988    {'41°53′7.5″N87°36′55.5″W' }
%     {'900 North Michigan'                 }         871            266          66      1989    {'41°53′59″N87°37′30″W'    }
%     {'Franklin Center'                    }        1007            307          61      1989    {'41°52′49.5″N87°38′5″W'   }
%     {'Leo Burnett Building'               }         635            194          50      1989    {'41°53′11″N87°37′45″W'    }
%     {'NBC Tower'                          }         627            191          37      1989    {'41°53′24″N87°37′16″W'    }
%     {'181 West Madison Street'            }         680            207          50      1990    {'41°52′53.5″N87°38′00″W'  }
%     {'311 South Wacker Drive'             }         961            293          65      1990    {'41°52′39″N87°38′8″W'     }
%     {'Boeing International Headquarters'  }         560            171          36      1990    {'41°53′2.5″N87°38′19″W'   }
%     {'North Pier Apartments'              }         581            177          61      1990    {'41°53′27″N87°36′52.5″W'  }
%     {'Two Prudential Plaza'               }         995            303          64      1990    {'41°53′8″N87°37′22″W'     }
%     {'Chicago Place'                      }         608            185          49      1991    {'41°53′43″N87°37′30.5″W'  }
%     {'The Parkshore'                      }         556            169          56      1991    {'41°53′8.5″N87°36′53″W'   }
%     {'77 West Wacker Drive'               }         668            204          49      1992    {'41°53′11.5″N87°37′50″W'  }
%     {'Grant Thornton Tower'               }         755            230          50      1992    {'41°53′5″N87°37′50″W'     }
%     {'Heller International Building'      }         600            183          45      1992    {'41°52′51″N87°38′25″W'    }
%     {'Park Tower'                         }         844            257          67      2000    {'41°53′49.5″N87°37′30.5″W'}
%     {'One North Wacker'                   }         652            199          50      2001    {'41°52′56″N87°38′10″W'    }
%     {'River East Center'                  }         644            196          58      2001    {'41°53′29″N87°37′5.5″W'   }
%     {'55 East Erie Street'                }         647            197          56      2003    {'41°53′38″N87°37′33″W'    }
%     {'Citadel Center'                     }         580            177          39      2003    {'41°52′47″N87°37′43″W'    }
%     {'Grand Plaza I'                      }         641            195          57      2003    {'41°53′31″N87°37′43″W'    }
%     {'Millennium Centre'                  }         610            186          58      2003    {'41°53′35″N87°37′45″W'    }
%     {'The Fordham'                        }         574            175          52      2003    {'41°53′43.5″N87°37′38″W'  }
%     {'111 South Wacker Drive'             }         681            208          51      2005    {'41°52′49″N87°38′10.5″W'  }
%     {'71 South Wacker'                    }         679            207          48      2005    {'41°52′51″N87°38′10″W'    }
%     {'One South Dearborn'                 }         571            174          39      2005    {'41°52′54″N87°37′43″W'    }
%     {'The Heritage at Millennium Park'    }         631            192          57      2005    {'41°53′3″N87°37′32″W'     }
%     {'340 on the Park'                    }         672            205          64      2007    {'41°53′5.5″N87°37′8″W'    }
%     {'The Clare'                          }         589            179          52      2008    {'41°53′50″N87°37′34″W'    }
%     {'155 North Wacker'                   }         638            195          45      2009    {'41°53′5″N87°38′11.5″W'   }
%     {'300 North LaSalle'                  }         784            239          60      2009    {'41°53′17.5″N87°37′59″W'  }
%     {'353 North Clark'                    }         624            190          44      2009    {'41°53′20″N87°37′48″W'    }
%     {'Aqua'                               }         860            262          82      2009    {'41°53′11″N87°37′12″W'    }
%     {'Atwater Apartments'                 }         554            169          55      2009    {'41°53′32″N87°37′5″W'     }
%     {'One Museum Park'                    }         726            221          62      2009    {'41°52′1.5″N87°37′17″W'   }
%     {'Trump International Hotel and Tower'}        1388            423          98      2009    {'41°53′20″N87°37′35″W'    }
%     {'Blue Cross Blue Shield Tower'       }         744            227          57      2010    {'41°53′5″N87°37′12″W'     }
%     {'The Grant'                          }         595            181          54      2010    {'41°52′1.5″N87°37′19″W'   }
%     {'The Legacy at Millennium Park'      }         822            251          73      2010    {'41°52′53″N87°37′32″W'    }
%     {'Waldorf Astoria Chicago'            }         686            209          60      2010    {'41°53′59″N87°37′39″W'    }
%     {'OneEleven'                          }         630            192          59      2014    {'41°53′12″N87°37′52″W'    }
%     {'Loews Hotel Tower'                  }         569            174          52      2015    {'41°53′23.9″N87°37′8″W'   }
%     {'150 North Riverside'                }         752            229          54      2017    {'41°53′4.1″N87°38′20.6″W' }
%     {'Optima Signature'                   }         587            179          57      2017    {'41°53′28″N87°37′17″W'    }
%     {'River Point'                        }         732            223          52      2017    {'41°53′9.3″N87°38′21.8″W' }
%     {'151 North Franklin'                 }         568            173          35      2018    {'41°53′5.28″N87°38′6″W'   }
%     {'One Bennett Park'                   }         837            255          69      2018    {'41°53′29″N87°36′56″W'    }
%     {'Essex on the Park'                  }         620            189          57      2019    {'41°52′04″N87°37′15″W'    }
%     {'NEMA Chicago'                       }         896            273          76      2019    {'41°52′1″N87°37′23″W'     }
%     {'110 North Wacker'                   }         814            248          51      2020    {'41°53′1″N87°38′15″W'     }
%     {'St. Regis Chicago'                  }        1198            363         101      2020    {'41°53′13″N87°37′03″W'    }
%     {'Wolf Point East Tower'              }         668            204          60      2020    {'41°53′15.0″N87°38′12.4″W'}
%     {'BMO Tower'                          }         729            222          51      2022    {'41°52′38″N87°38′26″W'    }
%     {'Cirrus'                             }         562            171          37      2022    {'41°53′10″N87°36′55″W'    }
%     {'One Chicago East Tower'             }         973            296          78      2022    {'41°53′46.2″N87°37′43.6″W'}
%     {'One Chicago West Tower'             }         574            174          49      2022    {'41°53′46.2″N87°37′43.6″W'}
%     {'Salesforce Tower Chicago'           }         835            255          60      2023    {'41°53′15.4″N87°38′15.7″W'}
%     {'1000M'                              }         805            245          73      2024    {'41°52′10.6″N87°37′27.8″W'}


% Question 3

% struct2table(mergesort(skyscrapers, @(x,y)false))
% This piece of code returns the list in reversed order

